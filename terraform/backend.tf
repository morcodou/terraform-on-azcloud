# gmc-backend-rg
# gmc-web-vnet 
# gmc-web-subnet
# gmc-web-nic
# gmc-web-nsg
# gmc-web-win-vm

resource "azurerm_resource_group" "backendrg" {
  name     = "${var.env}${var.backendrg-name}"
  location = var.location-name
}

module "web-vnet" {
  source              = "Azure/vnet/azurerm"
  vnet_name           = "${var.env}web-vnet"
  resource_group_name = azurerm_resource_group.backendrg.name
  address_space       = ["10.0.2.0/23"]
  subnet_prefixes     = ["10.0.2.0/24"]
  subnet_names        = ["${var.env}${var.websubnet-name}"]
  tags                = {}
  depends_on          = [azurerm_resource_group.backendrg]
}

# module.web-vnet.vnet_address_space=The address space of the newly created vNet
# module.web-vnet.vnet_id= The id of the newly created vNet
# module.web-vnet.vnet_location=The location of the newly created vNet
# module.web-vnet.vnet_name= The Name of the newly created vNet
# module.web-vnet.vnet_subnets = The ids of subnets created inside the newl vNet

module "web-compute" {
  source         = "../modules/compute"
  location       = azurerm_resource_group.backendrg.location
  subnet-id      = module.web-vnet.vnet_subnets[0]
  vm-name        = "${var.env}gmc-web"
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
