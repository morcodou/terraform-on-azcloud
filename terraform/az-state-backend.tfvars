# terraform init -backend-config az-state-backend.tfvars

resource_group_name  = "gmc-storage-rg"
storage_account_name = "gmctfazsac"
container_name       = "tfstate"
key                  = "workspace.tfsate"
