resource "azapi_resource_action" "ssh_public_key_gen" {
  type        = "Microsoft.Compute/sshPublicKeys@2023-03-01"
  resource_id = azapi_resource.new_ssh_public_key.id
  action      = "generateKeyPair"
  method      = "POST"

  response_export_values = ["publicKey", "privateKey"]
}

resource "azapi_resource" "new_ssh_public_key" {
  type      = "Microsoft.Compute/sshPublicKeys@2023-03-01"
  name      = var.ssh_key_name
  location  = azurerm_resource_group.twapp.location
  parent_id = azurerm_resource_group.twapp.id
}

output "key_data" {
  value = jsondecode(azapi_resource_action.ssh_public_key_gen.output).publicKey
}