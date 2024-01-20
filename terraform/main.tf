terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.85.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "BS23-Test-RG"
    storage_account_name = "bs23storage"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "aks_rg" {
  name     = var.RG
  location = var.LOCATION
}

module "vnet" {
  source    = "./modules/vnet"
  VNET_NAME = "BS23-VNet"
  LOCATION  = var.LOCATION
  RG        = var.RG

  depends_on = [ azurerm_resource_group.aks_rg ]
}

module "cluster" {
  source = "./modules/cluster"

  SUBENT_ID = module.vnet.SUBENT_ID_OUTPUT
  RG        = var.RG
  LOCATION  = var.LOCATION
  NAME      = "BS23-AKS-Cluster"
  PUBLIC_IP = module.vnet.PUBLIC_IP_OUTPUT

  depends_on = [ azurerm_resource_group.aks_rg, module.vnet ]
}
