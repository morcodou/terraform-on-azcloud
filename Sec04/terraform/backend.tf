# gmc-backend-rg
# gmc-web-vnet 
# gmc-web-subnet
# gmc-web-nic
# gmc-web-nsg
# gmc-web-win-vm

resource "azurerm_resource_group" "backendrg" {
  name     = "gmc-backend-rg"
  location = "canadacentral"
}

resource "azurerm_virtual_network" "webvnet" {
  name                = "gmc-web-vnet"
  location            = azurerm_resource_group.backendrg.location
  resource_group_name = azurerm_resource_group.backendrg.name
  address_space       = ["10.0.2.0/23"]
}

resource "azurerm_subnet" "websubnet" {
  name                 = "gmc-web-subnet"
  resource_group_name  = azurerm_resource_group.backendrg.name
  virtual_network_name = azurerm_virtual_network.webvnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "webnic" {
  name                = "gmc-web-nic"
  location            = azurerm_resource_group.backendrg.location
  resource_group_name = azurerm_resource_group.backendrg.name

  ip_configuration {
    name                          = "web-nic-internal"
    subnet_id                     = azurerm_subnet.websubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_security_group" "webnsg" {
  name                = "gmc-web-nsg"
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
  destination_address_prefix  = azurerm_network_interface.webnic.private_ip_address / 32
  resource_group_name         = azurerm_resource_group.backendrg.name
  network_security_group_name = azurerm_network_security_group.webnsg.name
}

resource "azurerm_subnet_network_security_group_association" "webtonsg" {
  subnet_id                 = azurerm_subnet.websubnet.id
  network_security_group_id = azurerm_network_security_group.webnsg.id
}

resource "azurerm_windows_virtual_machine" "webwinvm" {
  name                = "gmc-web-win-vm"
  resource_group_name = azurerm_resource_group.backendrg.name
  location            = azurerm_resource_group.backendrg.location
  size                = "Standard_B2s"
  admin_username      = "morcodou"
  admin_password      = "P@$$w0rd1234!"
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
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "commandToExecute": "powershell Install-WindowsFeature -name Web-Server -IncludeManagementTools;"
    }
SETTINGS
}