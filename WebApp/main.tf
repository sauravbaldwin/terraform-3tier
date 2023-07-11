resource "azurerm_service_plan" "asp" {
  name                = var.aspname
  location            = var.location
  resource_group_name = var.rgname
  kind = var.oskind

  sku {
    tier = var.skutier
    size = var.skusize
  }
}

resource "azurerm_app_service" "webapp" {
  count = 2 
  name                = "${var.aspname}-00${count.index}-p"
  location            = var.location
  resource_group_name = var.rgname
  app_service_plan_id = var.aspid

  site_config {
    dotnet_framework_version = "v4.0"

  }

  app_settings = {
    "SOME_KEY" = "some-value"
  }
}