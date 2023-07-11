resource "azurerm_network_security_group" "nsg" {
  name                = "subnet1-nsg"
  location            = var.location
  resource_group_name = var.rgname
}
 
resource "azurerm_network_security_rule" "nsgrule" {
  name                        = "test123"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.rgname
  network_security_group_name = azurerm_network_security_group.nsg.name
}
