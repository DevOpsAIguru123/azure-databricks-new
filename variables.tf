variable "databricks_host" {
  description = "Databricks workspace URL (e.g. https://adb-123456789.0.azuredatabricks.net)"
  type        = string
}

variable "azure_workspace_resource_id" {
  description = "Azure resource ID of the Databricks workspace (e.g. /subscriptions/.../resourceGroups/.../providers/Microsoft.Databricks/workspaces/...)"
  type        = string
}

variable "azure_client_id" {
  description = "Azure AD service principal application (client) ID"
  type        = string
}

variable "azure_client_secret" {
  description = "Azure AD service principal client secret"
  type        = string
  sensitive   = true
}

variable "azure_tenant_id" {
  description = "Azure AD tenant ID"
  type        = string
}
