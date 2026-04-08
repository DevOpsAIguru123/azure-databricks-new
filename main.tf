terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0"
    }
  }
}

provider "azuread" {
  client_id     = var.azure_client_id
  client_secret = var.azure_client_secret
  tenant_id     = var.azure_tenant_id
}

provider "databricks" {
  host                        = var.databricks_host
  azure_workspace_resource_id = var.azure_workspace_resource_id
  azure_client_id             = var.azure_client_id
  azure_client_secret         = var.azure_client_secret
  azure_tenant_id             = var.azure_tenant_id
}

data "azuread_group" "rag_admins" {
  display_name = "rag-admins"
  #security_enabled = true
}

resource "databricks_group" "rag_admins" {
  display_name          = "rag-admins"
  external_id           = data.azuread_group.rag_admins.object_id
  workspace_access      = true
  allow_cluster_create  = true
  databricks_sql_access = true
}
