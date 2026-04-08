output "entra_group_object_id" {
  description = "The Entra ID object ID of the rag-admins group"
  value       = data.azuread_group.rag_admins.object_id
}

output "databricks_group_id" {
  description = "The Databricks group ID of the rag-admins group"
  value       = databricks_group.rag_admins.id
}
