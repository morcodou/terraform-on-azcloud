# gmc-backend-rg
# gmc-web-vnet 
# gmc-web-subnet
# gmc-web-nic
# gmc-web-nsg
# gmc-web-win-vm

resource "azurerm_resource_group" "backendrg" {
  name     = var.backendrg-name
  location = var.location-name
}

resource "azurerm_virtual_network" "webvnet" {
  name                = var.webvnet-name
  location            = azurerm_resource_group.backendrg.location
  resource_group_name = azurerm_resource_group.backendrg.name
  address_space       = ["10.0.2.0/23"]
}

resource "azurerm_subnet" "websubnet" {
  name                 = var.websubnet-name
  resource_group_name  = azurerm_resource_group.backendrg.name
  virtual_network_name = azurerm_virtual_network.webvnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "webnic" {
  name                = var.webnic-name
  location            = azurerm_resource_group.backendrg.location
  resource_group_name = azurerm_resource_group.backendrg.name

  ip_configuration {
    name                          = "web-nic-internal"
    subnet_id                     = azurerm_subnet.websubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_security_group" "webnsg" {
  name                = var.webnsg-name
  location            = azurerm_resource_group.backendrg.location
  resource_group_name = azurerm_resource_group.backendrg.name
}

resource "azurerm_network_security_rule" "allow-http" {
  name                        = "allow-http-rule"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "${azurerm_network_interface.webnic.private_ip_address}/32"
  resource_group_name         = azurerm_resource_group.backendrg.name
  network_security_group_name = azurerm_network_security_group.webnsg.name
}

resource "azurerm_network_interface_security_group_association" "backend-nic-seg" {
  network_interface_id      = azurerm_network_interface.webnic.id
  network_security_group_id = azurerm_network_security_group.webnsg.id
}

resource "azurerm_windows_virtual_machine" "webwinvm" {
  name                = var.webwinvm-name
  resource_group_name = azurerm_resource_group.backendrg.name
  location            = azurerm_resource_group.backendrg.location
  size                = "Standard_B2s"
  admin_username      = var.admin-username
  admin_password      = var.admin-password
  network_interface_ids = [
    azurerm_network_interface.webnic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_virtual_machine_extension" "webserverextension" {
  name                 = "iis-web-extension"
  virtual_machine_id   = azurerm_windows_virtual_machine.webwinvm.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = <<SETTINGS
    {
        "commandToExecute": "powershell Install-WindowsFeature -name Web-Server -IncludeManagementTools;"
    }
SETTINGS
}