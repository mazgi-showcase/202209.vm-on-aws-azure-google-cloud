resource "azurerm_network_security_group" "main" {
  name                = "${var.project_unique_id}-main"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = {}
}

resource "azurerm_network_security_rule" "allow-from-allowed-list" {
  name                        = "${var.project_unique_id}-allow-from-allowed-list"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.main.name
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefixes     = var.allowed_ipaddr_list
  destination_address_prefix  = "*"
}
