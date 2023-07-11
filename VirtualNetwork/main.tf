resource "azurerm_virtual_network" "vnet3" {
  name                = var.vnetname
  location            = var.location
  resource_group_name = var.rgname
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name           = "${var.vnetname}-subnet1"
    address_prefix = "10.0.1.0/27"
    security_group = var.nsgname
  
  }

  subnet {
    name           = "${var.vnetname}-subnet2"
    address_prefix = "10.0.2.0/27"
    security_group = var.nsgname

  }

}
