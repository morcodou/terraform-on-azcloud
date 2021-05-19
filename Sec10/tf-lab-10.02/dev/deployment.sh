export ARM_CLIENT_ID=$(SP_CLIENT_ID)
export ARM_CLIENT_SECRET=$(SP_CLIENT_SECRET)
export ARM_SUBSCRIPTION_ID=$(SP_SUBSCRIPTION_ID)
export ARM_TENANT_ID=$(SP_TENANT_ID)
terraform init -backend-config backend.tfvars
terraform plan
terraform apply -auto-approve
unset ARM_CLIENT_ID
unset ARM_CLIENT_SECRET
unset ARM_SUBSCRIPTION_ID
unset ARM_TENANT_ID