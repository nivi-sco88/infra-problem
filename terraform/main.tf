data "azuread_client_config" "current" {}

resource "azurerm_resource_group" "twapp" {
  name     = var.twappname
  location = var.location
}

resource "azurerm_kubernetes_cluster" "aks-cluster" {
  depends_on = [ azurerm_public_ip.aks-public-ip ]
  name                  = var.aks_cluster_name
  location              = azurerm_resource_group.twapp.location
  resource_group_name   = azurerm_resource_group.twapp.name
  dns_prefix            = "${azurerm_resource_group.twapp.name}-cluster"           
  
  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name       = "agentpool"
    vm_size    = "Standard_D2s_v3"
    node_count = var.node_count
     } 

    linux_profile {
      admin_username = var.username

      ssh_key {
        key_data = jsondecode(azapi_resource_action.ssh_public_key_gen.output).publicKey
      }
    }

    network_profile {
      network_plugin = "kubenet"
      load_balancer_sku = "standard"
      outbound_type      = "loadBalancer"
      load_balancer_profile {
        outbound_ip_address_ids = [azurerm_public_ip.aks-public-ip.id]
  }
  }
    
  }

resource "azurerm_public_ip" "aks-public-ip" {
    name                = "aks-public-ip"
    resource_group_name = azurerm_resource_group.twapp.name
    allocation_method   = "Static"
    sku                 = "Standard"
    location = azurerm_resource_group.twapp.location
}

terraform {
  backend "azurerm" {
    storage_account_name = "twappstorageaccount"
    container_name       = "twappcontainer"
    key                  = "terraform.tfstate"
  }
}
