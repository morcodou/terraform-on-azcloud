# # Please use terraform v12.29 to start with for all labs, I will use terraform v13 and v14 from lab 7.5 onwards

provider "azurerm" {
  version = "= 2.19"
  features {}
}

data "azurerm_client_config" "current" {

}

resource "azurerm_resource_group" "resourcegroup" {
  name     = "gmcterraformazrg"
  location = "canadacentral"
}

resource "azurerm_key_vault" "keyvault" {
  name                = "gmcterraformazkv"
  location            = azurerm_resource_group.resourcegroup.location
  resource_group_name = azurerm_resource_group.resourcegroup.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
}

resource "azurerm_storage_account" "storageaccount" {
  name                     = "gmcterraformazsac"
  resource_group_name      = "gmcterraformazrg"
  location                 = "canadacentral"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
