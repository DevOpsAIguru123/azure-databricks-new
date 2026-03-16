################################################################################
# 3. Security: Role Assignments and CMK
################################################################################

# Assign crypto permissions to DBFS managed identity
resource "azurerm_role_assignment" "databricks_dbfs_storage" {
  for_each             = local.workspace_config
  scope                = data.azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_databricks_workspace.dbw[each.key].storage_account_identity[0].principal_id
  depends_on           = [data.azurerm_key_vault.kv, azurerm_databricks_workspace.dbw]
}

# Assign crypto permissions to Managed Disk identity
resource "azurerm_role_assignment" "databricks_disk_storage" {
  for_each             = local.workspace_config
  scope                = data.azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_databricks_workspace.dbw[each.key].managed_disk_identity[0].principal_id
  depends_on           = [data.azurerm_key_vault.kv, azurerm_databricks_workspace.dbw]
}

# Configure DBFS Root Customer Managed Key
resource "azurerm_databricks_workspace_root_dbfs_customer_managed_key" "cmk_dbfs_root" {
  for_each         = local.workspace_config
  workspace_id     = azurerm_databricks_workspace.dbw[each.key].id
  key_vault_key_id = each.value.cmk_dbfs_root_key_vault_key_id
  depends_on       = [azurerm_databricks_workspace.dbw, azurerm_role_assignment.databricks_dbfs_storage]
}
