provider "azurerm" {
    version = "~>2.0"
    features {}
}

terraform {
    backend "azurerm" {
        resource_group_name = "rg-test-eastus-01"    
        storage_account_name = "stgtesteastus01"
        container_name = "tfstate"
    }
}

resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}