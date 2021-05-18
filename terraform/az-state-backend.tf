terraform {
  required_providers {
    az = {
      source  = "hashicorp/azurerm"
      version = "= 2.19"
      # resource_group_name  = "gmc-storage-rg"
      # storage_account_name = "gmctfazsac"
      # container_name       = "tfstate"
      # key                  = "workspace.tfsate"
    }
  }
  # backend "azurerm" {
  #   resource_group_name  = "gmc-storage-rg"
  #   storage_account_name = "gmctfazsac"
  #   container_name       = "tfstate"
  #   key                  = "workspace.tfsate"
  # }
}
