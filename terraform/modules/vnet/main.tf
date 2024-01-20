resource "azurerm_virtual_network" "aks_vnet" {
  name                = var.VNET_NAME
  location            = var.LOCATION
  resource_group_name = var.RG
  address_space       = ["10.224.0.0/12"]
}

resource "azurerm_subnet" "aks_default_subnet" {
  name                 = "default"
  resource_group_name  = var.RG
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes     = ["10.224.0.0/16"]

  depends_on = [azurerm_virtual_network.aks_vnet]
}

resource "azurerm_public_ip" "aks_public_ip" {
  name                = "BS23-Public_IP"
  location            = var.LOCATION
  resource_group_name = var.RG
  allocation_method   = "Dynamic"
}