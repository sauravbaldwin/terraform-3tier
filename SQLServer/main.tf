resource "azurerm_mssql_server" "sqlser" {
  name                         = var.sqlsername
  resource_group_name          = var.rgname
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.adminlogin
  administrator_login_password = var.adminpassword
  minimum_tls_version          = "1.2"

  azuread_administrator {
    login_username = var.adminloginusername
    object_id      = var.adadminuserobject
  }
}
