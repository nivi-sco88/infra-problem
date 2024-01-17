terraform {
  required_version = ">=1.0"

required_providers {
    azapi = {
      source  = "azure/azapi"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
    }
}
}
provider "azurerm" {
  features {}
}

provider "azapi" {
}