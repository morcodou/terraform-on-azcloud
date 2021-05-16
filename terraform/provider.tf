provider "azurerm" {
  version = "= 2.19"
  features {}
}

data "azurerm_client_config" "current" {

}