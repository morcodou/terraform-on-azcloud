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

resource "azurerm_virtual_network" "frontendvnet" {
  name                = "gmc-frontend-vnet"
  location            = azurerm_resource_group.frontendrg.location
  resource_group_name = azurerm_resource_group.frontendrg.name
  address_space       = ["10.0.0.0/23"]
}

resource "azurerm_subnet" "azfirewallsubnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.frontendrg.name
  virtual_network_name = azurerm_virtual_network.frontendvnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "jumpboxsubnet" {
  name                 = "gmc-jumpbox-subnet"
  resource_group_name  = azurerm_resource_group.frontendrg.name
  virtual_network_name = azurerm_virtual_network.frontendvnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

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
    subnet_id            = azurerm_subnet.azfirewallsubnet.id
    public_ip_address_id = azurerm_public_ip.firewallpip.id
  }
}