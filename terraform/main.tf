data "azuread_client_config" "current" {}

resource "azurerm_resource_group" "twapp" {
  name     = var.twappname
  location = var.location
}

resource "azuread_application" "twapp" {
  display_name = var.service_principal_name
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "twapp-sp" {
  client_id                    = azuread_application.twapp.client_id
  app_role_assignment_required = true
  owners                       = [data.azuread_client_config.current.object_id]
  depends_on                   = [azurerm_resource_group.twapp]
}

resource "azuread_service_principal_password" "sp_pass" {
  service_principal_id = azuread_service_principal.twapp-sp.object_id
}

resource "azurerm_role_assignment" "rolespn" {

  scope                = "/subscriptions/53589d9c-dcbc-4d1b-9617-6f773c239fae"
  role_definition_name = "contributor"
  principal_id         = azuread_service_principal.twapp-sp.object_id
  depends_on           = [azuread_service_principal.twapp-sp]
}
data "azurerm_client_config" "current" {}

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
  name         = azuread_service_principal.twapp-sp.client_id
  value        = azuread_service_principal_password.sp_pass.value
  key_vault_id = azurerm_key_vault.vault.id
}

resource "azurerm_container_registry" "twapp-reg" {
  name                = var.registry_name
  resource_group_name = azurerm_resource_group.twapp.name
  location            = azurerm_resource_group.twapp.location
  sku                 = "Basic"
}

#create Azure Kubernetes Service
module "aks" {
  source                 = "./aks/"
  service_principal_name = var.service_principal_name
  client_id              = azuread_service_principal.twapp-sp.client_id
  client_secret          = azuread_service_principal_password.sp_pass.value
  location               = var.location
  resource_group_name    = var.twappname

  depends_on = [
    azuread_service_principal.twapp-sp
  ]

}
