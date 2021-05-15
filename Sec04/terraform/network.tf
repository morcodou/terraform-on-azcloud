resource "azurerm_virtual_network_peering" "frenttoback" {
  name                      = "frontend-to-backend"
  resource_group_name       = azurerm_resource_group.frontendrg.name
  virtual_network_name      = azurerm_virtual_network.frontendvnet.name
  remote_virtual_network_id = azurerm_virtual_network.webvnet.id
}

resource "azurerm_virtual_network_peering" "backtofrent" {
  name                      = "backend-to-frontend"
  resource_group_name       = azurerm_resource_group.backendrg.name
  virtual_network_name      = azurerm_virtual_network.webvnet.name
  remote_virtual_network_id = azurerm_virtual_network.frontendvnet.id
}

resource "azurerm_firewall_nat_rule_collection" "firewallnatrules" {
  name                = "firewall-nat-rules"
  azure_firewall_name = azurerm_firewall.firewall.name
  resource_group_name = azurerm_resource_group.frontendrg.name
  priority            = 100
  action              = "Dnat"

  rule {
    name = "webrule"

    source_addresses = [
      "*",
    ]

    destination_ports = [
      "80",
    ]

    destination_addresses = [
      azurerm_public_ip.firewallpip.ip_address
    ]

    translated_port = 80

    translated_address = azurerm_network_interface.webnic.private_ip_address

    protocols = [
      "TCP"
    ]
  }

  rule {
    name = "jumpboxrule"

    source_addresses = [
      "*",
    ]

    destination_ports = [
      "3389",
    ]

    destination_addresses = [
      azurerm_public_ip.firewallpip.ip_address
    ]

    translated_port = 3389

    translated_address = azurerm_network_interface.jumpboxnic.private_ip_address

    protocols = [
      "TCP"
    ]
  }
}

resource "azurerm_network_security_rule" "allowrdpfirnat" {
  name                        = "allow-rdp-nat-rule"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "${azurerm_network_interface.jumpboxnic.private_ip_address}/32"
  destination_address_prefix  = "${azurerm_network_interface.webnic.private_ip_address}/32"
  resource_group_name         = azurerm_resource_group.backendrg.name
  network_security_group_name = azurerm_network_security_group.webnsg.name
}