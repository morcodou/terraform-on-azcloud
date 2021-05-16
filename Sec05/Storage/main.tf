
provider "azurerm" {
  version = "= 2.19"
  features {}
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "resourcegroup" {
  name     = "gmc-storage-rg"
  location = "canadacentral"
}

resource "azurerm_key_vault" "keyvault" {
  name                = "gmc-tfaz-kv"
  location            = azurerm_resource_group.resourcegroup.location
  resource_group_name = azurerm_resource_group.resourcegroup.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
}

resource "azurerm_storage_account" "storageaccount" {
  name                     = "gmctfazsac"
  resource_group_name      = azurerm_resource_group.resourcegroup.name
  location                 = azurerm_resource_group.resourcegroup.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.storageaccount.name
  container_access_type = "private"
}