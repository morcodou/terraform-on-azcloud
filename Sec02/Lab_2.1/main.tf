# Please use terraform v12.29 to start with for all labs, I will use terraform v13 from lab 7.5 onwards

provider "azurerm" {
  version = "= 2.18"
  features {}
}

resource "azurerm_resource_group" "myrg" {
  name     = "terraform-on-az-lab0021-rg"
  location = "canadacentral"
}