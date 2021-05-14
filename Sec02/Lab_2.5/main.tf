provider "azurerm" {
  version = "= 2.19"
  features {}
}

resource "azurerm_resource_group" "resourcegroup" {
  name     = "gmcterraformazrg"
  location = "canadacentral"
}

resource "azurerm_key_vault" "keyvault" {
  name                        = "gmcterraformazkv"
  location                    = azurerm_resource_group.resourcegroup.location
  resource_group_name         = azurerm_resource_group.resourcegroup.name
  tenant_id                   = TENANT_ID
  sku_name                    = "standard"
}

resource "azurerm_storage_account" "storageaccount" {
  name                      = "gmcterraformazsac"
  resource_group_name       = azurerm_resource_group.resourcegroup.name
  location                  = azurerm_resource_group.resourcegroup.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
}

# # Please use terraform v12.29 to start with for all labs, I will use terraform v13 and v14 from lab 7.5 onwards
# provider "azurerm" {
#   version = "= 2.18"
#   features {}
# }

# resource "azurerm_resource_group" "rg" {
#   name     = "Terra-rg"
#   location = "West Europe"
# }

# data "azurerm_client_config" "current" {}

# resource "azurerm_key_vault" "rg" {
#   name                = "kvult-01"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   tenant_id           = data.azurerm_client_config.current.tenant_id
#   sku_name            = "standard"
#   access_policy {
#     tenant_id = data.azurerm_client_config.current.tenant_id
#     object_id = data.azurerm_client_config.current.object_id
#     key_permissions = [
#       "get", "list", "create", "delete", "update",
#     ]
#     secret_permissions = [
#       "get", "list", "set", "delete",
#     ]
#   }
# }

# resource "azurerm_storage_account" "rg" {
#   name                     = "remotesa01"
#   resource_group_name      = azurerm_resource_group.rg.name
#   location                 = azurerm_resource_group.rg.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
# }