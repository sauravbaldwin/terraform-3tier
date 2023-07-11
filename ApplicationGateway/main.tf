resource "azurerm_subnet" "frontend" {
  name                 = "frontend"
  resource_group_name  = var.rgname
  virtual_network_name = var.vnetname
  address_prefixes     = ["10.254.0.0/27"]
}

resource "azurerm_subnet" "backend" {
  name                 = "backend"
  resource_group_name  = var.rgname
  virtual_network_name = var.vnetname
  address_prefixes     = ["10.254.2.0/27"]
}

resource "azurerm_public_ip" "apgw-pip" {
  name                = "${var.apgwname}-pip"
  resource_group_name = var.rgname
  location            = var.location
  allocation_method   = "Dynamic"
}

# since these variables are re-used - a locals block makes this more maintainable
locals {
  backend_address_pool_name      = "${var.apgwname}-beap"
  frontend_port_name             = "${var.apgwname}-feport"
  frontend_ip_configuration_name = "${var.apgwname}-feip"
  http_setting_name              = "${var.apgwname}-be-htst"
  listener_name                  = "${var.apgwname}-httplstn"
  request_routing_rule_name      = "${var.apgwname}-rqrt"
  redirect_configuration_name    = "${var.apgwname}-rdrcfg"
}

resource "azurerm_application_gateway" "apgw" {
  name                = var.apgwname
  resource_group_name = var.rgname
  location            = var.location

  sku {
    name     = var.skuname
    tier     = var.skutier
    capacity = var.skucapacity
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = azurerm_subnet.frontend.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.apgw-pip.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/path1/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }
}
