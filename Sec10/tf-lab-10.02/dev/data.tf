data "azurerm_key_vault" "kvname" {
  name                = "gmc-tfaz-kv"
  resource_group_name = "gmc-storage-rg"
}

data "azurerm_key_vault_secret" "kvsecret" {
  name         = "admin-password"
  key_vault_id = data.azurerm_key_vault.kvname.id
}
