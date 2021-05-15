# gmc-jumpbox-rg
# gmc-jumpbox-nsg
# gmc-jumpbox-nic
# gmc-jumpbox-win-vm

resource "azurerm_resource_group" "jumpboxrg" {
  name     = "gmc-jumpbox-rg"
  location = "canadacentral"
}

resource "azurerm_network_interface" "jumpboxnic" {
  name                = "gmc-jumpbox-nic"
  location            = azurerm_resource_group.jumpboxrg.location
  resource_group_name = azurerm_resource_group.jumpboxrg.name

  ip_configuration {
    name                          = "jumpbox-nic-internal"
    subnet_id                     = azurerm_subnet.websubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_security_group" "jumpboxnsg" {
  name                = "gmc-jumpbox-nsg"
  location            = azurerm_resource_group.jumpboxrg.location
  resource_group_name = azurerm_resource_group.jumpboxrg.name
}

resource "azurerm_network_security_rule" "allowrdp" {
  name                        = "allow-rdp-rule"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "${azurerm_network_interface.jumpboxnic.private_ip_address}/32"
  resource_group_name         = azurerm_resource_group.jumpboxrg.name
  network_security_group_name = azurerm_network_security_group.jumpboxnsg.name
}

resource "azurerm_network_interface_security_group_association" "webtojumpboxnsg" {
  network_interface_id      = azurerm_network_interface.jumpboxnic.id
  network_security_group_id = azurerm_network_security_group.jumpboxnsg.id
}

resource "azurerm_windows_virtual_machine" "jumpboxvm" {
  name                = "gmc-jumpbox-vm"
  resource_group_name = azurerm_resource_group.jumpboxrg.name
  location            = azurerm_resource_group.jumpboxrg.location
  size                = "Standard_B2s"
  admin_username      = "morcodou"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.jumpboxnic.id,
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
