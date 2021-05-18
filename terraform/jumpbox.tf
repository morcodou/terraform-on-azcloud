# gmc-jumpbox-rg
# gmc-jumpbox-nsg
# gmc-jumpbox-nic
# gmc-jumpbox-win-vm

resource "azurerm_resource_group" "jumpboxrg" {
  name     = "${var.env}gmc-jumpbox-rg"
  location = var.location-name
}

module "jumbox-compute" {
  source         = "../modules/compute"
  location       = azurerm_resource_group.jumpboxrg.location
  subnet-id      = module.frontend-vnet.vnet_subnets[1]
  vm-name        = "${var.env}gmc-jumpbox"
  rg-name        = azurerm_resource_group.jumpboxrg.name
  admin-password = data.azurerm_key_vault_secret.kvsecret.value
}

# module outputs
# module.jumbox-compute.nic-id
# module.jumbox-compute.vm-private-ip
# module.jumbox-compute.vm-id
# module.jumbox-compute.nsg-name
# module.jumbox-compute.nsg-id

resource "azurerm_network_security_rule" "allowrdp" {
  name                        = "allow-rdp-rule"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "${module.jumbox-compute.vm-private-ip}/32"
  resource_group_name         = azurerm_resource_group.jumpboxrg.name
  network_security_group_name = module.jumbox-compute.nsg-name
}

resource "azurerm_network_interface_security_group_association" "webtojumpboxnsg" {
  network_interface_id      = module.jumbox-compute.nic-id
  network_security_group_id = module.jumbox-compute.nsg-id
}
