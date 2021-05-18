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

# export ARM_CLIENT_ID="AZURE_CLIENT_ID"
# export ARM_CLIENT_SECRET="AZURE_CLIENT_SECRET"
# export ARM_TENANT_ID="AZURE_TENANT_ID"
# export ARM_SUBSCRIPTION_ID="AZURE_SUBSCRIPTION_ID"
