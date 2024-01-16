data "azuread_client_config" "current" {}

resource "azurerm_key_vault" "vault" {
  name                       = var.keyvault_name
  resource_group_name        = var.twappname
  location                   = var.location
  sku_name                   = "standard"
  tenant_id                  = data.azuread_client_config.current.tenant_id
  soft_delete_retention_days = 7
  enable_rbac_authorization  = true
}

resource "azurerm_key_vault_access_policy" "example_policy" {
  key_vault_id = azurerm_key_vault.vault.id

  tenant_id = data.azuread_client_config.current.tenant_id
  object_id = data.azuread_client_config.current.object_id

}

resource "azurerm_key_vault_secret" "name" {
  name         = var.client_id
  value        = var.client_secret
  key_vault_id = azurerm_key_vault.vault.id
}

resource "azurerm_container_registry" "twapp-reg" {
  name                = var.registry_name
  resource_group_name = var.twappname
  location            = var.location
  sku                 = "Basic"
}

#create Azure Kubernetes Service
module "aks" {
  source                 = "./aks/"
  client_id              = var.client_id
  client_secret          = var.client_secret
  location               = var.location
  resource_group_name    = var.twappname
  service_principal_name = var.client_id

}
