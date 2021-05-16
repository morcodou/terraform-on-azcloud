resource "azurerm_network_interface" "compute" {
  name                = "${var.vm-name}-nic"
  location            = var.location
  resource_group_name = var.rg-name

  ip_configuration {
    name                          = "${var.vm-name}-nic-internal"
    subnet_id                     = var.subnet-id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_security_group" "compute" {
  name                = "${var.vm-name}-nsg"
  location            = var.location
  resource_group_name = var.rg-name
}

resource "azurerm_windows_virtual_machine" "compute" {
  name                = "${var.vm-name}-vm"
  location            = var.location
  resource_group_name = var.rg-name
  size                = "Standard_B2s"
  admin_username      = "morcodou"
  admin_password      = var.admin-password
  network_interface_ids = [
    azurerm_network_interface.compute.id,
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
