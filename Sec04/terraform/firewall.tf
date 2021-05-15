# gmc-firewall-rg
# gmc-firewall-vnet 
# AzureFirewallSubnet
# jumpbox-subnet
# gmc-firewall-pip
# gmc-firewall

provider "azurerm" {
  version = "= 2.19"
  features {}
}

data "azurerm_client_config" "current" {

}

resource "azurerm_resource_group" "firewallrg" {
  name     = "gmc-firewall-rg"
  location = "canadacentral"
}

resource "azurerm_virtual_network" "firewallvnet" {
  name                = "gmc-firewall-vnet"
  location            = azurerm_resource_group.firewallrg.location
  resource_group_name = azurerm_resource_group.firewallrg.name
  address_space       = ["10.0.0.0/23"]
}

resource "azurerm_subnet" "azfirewallsubnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.firewallrg.name
  virtual_network_name = azurerm_virtual_network.firewallvnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "jumpboxsubnet" {
  name                 = "jumpbox-subnet"
  resource_group_name  = azurerm_resource_group.firewallrg.name
  virtual_network_name = azurerm_virtual_network.firewallvnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "firewallpip" {
  name                = "gmc-firewall-pip"
  resource_group_name = azurerm_resource_group.firewallrg.name
  location            = azurerm_resource_group.firewallrg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "firewall" {
  name                = "gmc-firewall"
  location            = azurerm_resource_group.firewallrg.location
  resource_group_name = azurerm_resource_group.firewallrg.name

  ip_configuration {
    name                 = "firewall-ip-config"
    subnet_id            = azurerm_subnet.azfirewallsubnet.id
    public_ip_address_id = azurerm_public_ip.firewallpip.id
  }
}