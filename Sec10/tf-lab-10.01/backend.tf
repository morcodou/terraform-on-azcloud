terraform {
  backend "azurerm" {
    resource_group_name  = "gmc-storage-rg"
    storage_account_name = "gmctfazsac"
    container_name       = "tfstate"
  }
}
