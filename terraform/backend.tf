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

module "web-compute" {
  source         = "../modules/compute"
  location       = azurerm_resource_group.backendrg.location
  subnet-id      = azurerm_subnet.websubnet.id
  vm-name        = "gmc-web"
  rg-name        = azurerm_resource_group.backendrg.name
  admin-password = var.admin-password
}
# module outputs
# module.web-compute.nic-id
# module.web-compute.vm-private-ip
# module.web-compute.vm-id
# module.web-compute.nsg-name
# module.web-compute.nsg-id

resource "azurerm_network_security_rule" "allow-http" {
  name                        = "allow-http-rule"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "${module.web-compute.vm-private-ip}/32"
  resource_group_name         = azurerm_resource_group.backendrg.name
  network_security_group_name = module.web-compute.nsg-name
}

resource "azurerm_network_interface_security_group_association" "backend-nic-seg" {
  network_interface_id      = module.web-compute.nic-id
  network_security_group_id = module.web-compute.nsg-id
}

resource "azurerm_virtual_machine_extension" "webserverextension" {
  name                 = "iis-web-extension"
  virtual_machine_id   = module.web-compute.vm-id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = <<SETTINGS
    {
        "commandToExecute": "powershell Install-WindowsFeature -name Web-Server -IncludeManagementTools;"
    }
SETTINGS
}