data "azurerm_subscription" "subscription_data" {}

resource "azurerm_user_assigned_identity" "aks_identity" {
  resource_group_name = var.RG
  location            = var.LOCATION
  name                = "${var.NAME}-Identity"
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  resource_group_name               = var.RG
  location                          = var.LOCATION
  name                              = var.NAME
  dns_prefix                        = "BS-Test-Cluster-dns"
  private_cluster_enabled           = false
  role_based_access_control_enabled = true
  sku_tier                          = "Free"

  azure_active_directory_role_based_access_control {
    tenant_id          = data.azurerm_subscription.subscription_data.tenant_id
    azure_rbac_enabled = true
    managed            = true
  }

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    enable_auto_scaling    = true
    enable_host_encryption = false
    enable_node_public_ip  = false
    fips_enabled           = false
    kubelet_disk_type      = "OS"
    max_count              = 5
    min_count              = 2
    max_pods               = 110
    name                   = "agentpool"
    node_count             = 2
    orchestrator_version   = "1.27.7"
    os_disk_size_gb        = 128
    ultra_ssd_enabled      = false
    vm_size                = "Standard_B2s"
    vnet_subnet_id         = var.SUBENT_ID
  }

  network_profile {
    dns_service_ip = "10.0.0.10"
    network_plugin = "kubenet"
    network_policy = "calico"
    outbound_type  = "loadBalancer"

    load_balancer_profile {
      effective_outbound_ips = [var.PUBLIC_IP]
    }
  }

  depends_on = [azurerm_user_assigned_identity.aks_identity, data.azurerm_subscription.subscription_data]
}
