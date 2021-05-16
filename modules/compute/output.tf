output "nic-id" {
  value = azurerm_network_interface.compute.id
}
output "vm-private-ip" {
  value = azurerm_network_interface.compute.private_ip_address
}
output "vm-id" {
  value = azurerm_windows_virtual_machine.compute.id
}
output "nsg-name" {
  value = azurerm_network_security_group.compute.name
}
output "nsg-id" {
  value = azurerm_network_security_group.compute.id
}