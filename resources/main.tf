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

resource "random_id" "random_password" {
  byte_length = 8
}

resource "azurerm_resource_group" "resourcegroup" {
  name     = var.resourceGroup
  location = var.location
}

resource "azurerm_virtual_network" "virtualnet" {
  name                = var.networkname
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

resource "azurerm_network_interface" "netinterface" {
  name                = var.networkinterface
  location            = var.location
  resource_group_name = azurerm_resource_group.resourcegroup.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
  }
}


resource "azurerm_linux_virtual_machine" "example" {
  name                = var.vmName
  resource_group_name = azurerm_resource_group.resourcegroup.name
  location            = var.location
  size                = var.vmSize
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.netinterface.id,
  ]

  admin_password = "${format("Pwd1234%s!", random_id.random_password.b64)}"
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo useradd -m vikas -p '${random_id.random_password.result}'",
      "sudo groupadd testgroup",
    ]
}