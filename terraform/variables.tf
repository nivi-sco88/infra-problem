variable "twappname" {
  type        = string
  description = "resource group name"
}
variable "location" {
  type        = string
  description = "location for resource group"
  default     = "East US"
}

variable "service_principal_name" {
  type = string
}

variable "keyvault_name" {
  type = string
}

variable "registry_name" {
  type = string
}

variable "subscription_id" {
  type = string
}

variable "client_id" {
    type = string
}

variable "client_secret" {
    type = string
}

variable "tenant_id" {
    type = string
}

variable "aks_cluster_name" {
    type = string
}

variable "node_count" {
  type = number
}

variable "username" {
  type = string
}

variable "ssh_key_name" {
  type = string
}