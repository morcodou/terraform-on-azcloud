output "firewall-pip" {
  value = azurerm_public_ip.firewallpip.ip_address
}
output "admin-password" {
  value = var.admin-password
  sensitive = true
}
