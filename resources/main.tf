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

resource "azurerm_resource_group" "resourcegroup" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "virtualnet" {
  name                = var.virtualnet
  location            = var.location
  address_space       = var.address
  resource_group_name = azurerm_resource_group.resourcegroup.name
}

resource "azurerm_subnet" "subnet1" {
  name                 = var.subnet
  virtual_network_name = azurerm_virtual_network.virtualnet.name
  resource_group_name  = azurerm_resource_group.resourcegroup.name
  address_prefixes     = var.addressprefix
}