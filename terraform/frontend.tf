# gmc-frontend-rg
# gmc-frontend-vnet 
# AzureFirewallSubnet
# gmc-jumpbox-subnet
# gmc-firewall-pip
# gmc-firewall

resource "azurerm_resource_group" "frontendrg" {
  name     = "gmc-frontend-rg"
  location = "canadacentral"
}

module "frontend-vnet" {
  source              = "Azure/vnet/azurerm"
  vnet_name           = "frontend-vnet"
  resource_group_name = azurerm_resource_group.frontendrg.name
  address_space       = ["10.0.0.0/23"]
  subnet_prefixes     = ["10.0.0.0/24", "10.0.1.0/24"]
  subnet_names        = ["AzureFirewallSubnet", "jumpbox-subnet"]
  tags                = {}
  depends_on          = [azurerm_resource_group.frontendrg]
}

# module.frontend-vnet.vnet_address_space=The address space of the newly created vNet
# module.frontend-vnet.vnet_id= The id of the newly created vNet
# module.frontend-vnet.vnet_location=The location of the newly created vNet
# module.frontend-vnet.vnet_name= The Name of the newly created vNet
# module.frontend-vnet.vnet_subnets = The ids of subnets created inside the newl vNet

resource "azurerm_public_ip" "firewallpip" {
  name                = "gmc-firewall-pip"
  resource_group_name = azurerm_resource_group.frontendrg.name
  location            = azurerm_resource_group.frontendrg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "firewall" {
  name                = "gmc-firewall"
  location            = azurerm_resource_group.frontendrg.location
  resource_group_name = azurerm_resource_group.frontendrg.name

  ip_configuration {
    name                 = "firewall-ip-config"
    subnet_id            = module.frontend-vnet.vnet_subnets[0]
    public_ip_address_id = azurerm_public_ip.firewallpip.id
  }
}
