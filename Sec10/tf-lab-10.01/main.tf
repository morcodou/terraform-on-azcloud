resource "azurerm_resource_group" "rgabc" {
  name     = "${var.env}-${var.abc}"
  location = var.location
  tags = {
    "kv-password" = var.admin-password
  }
}

resource "azurerm_virtual_network" "vneta" {
  name                = "${var.env}-gmc-vnet-A"
  address_space       = ["10.0.3.0/24"]
  location            = azurerm_resource_group.rgabc.location
  resource_group_name = azurerm_resource_group.rgabc.name
}

resource "azurerm_virtual_network" "vnetb" {
  name                = "${var.env}-gmc-vnet-B"
  address_space       = ["10.0.4.0/24"]
  location            = azurerm_resource_group.rgabc.location
  resource_group_name = azurerm_resource_group.rgabc.name
}
