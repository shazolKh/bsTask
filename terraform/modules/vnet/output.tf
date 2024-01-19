output "SUBENT_ID_OUTPUT" {
  value = azurerm_subnet.aks_default_subnet.id
}

output "PUBLIC_IP_OUTPUT" {
  value = azurerm_public_ip.aks_public_ip
}