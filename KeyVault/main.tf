resource "azurerm_key_vault" "akv" {
  name                        = var.akvname
  location                    = var.location
  resource_group_name         = var.rgname
  enabled_for_disk_encryption = true
  tenant_id                   = var.tenantid
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = var.akvskuname

  access_policy {
    tenant_id = var.tenantid
    object_id = var.objectid

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
    ]

    storage_permissions = [
      "Get",
    ]
  }
}
