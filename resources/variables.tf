variable "resource_group_name" {
  type        = string
  description = "Storage account name"
}

variable "location" {
  type        = string
  description = "Default Resources location"
  default     = "eastus"
}

variable "address" {
  type        = list(string)
  description = "Default Address"
  default     = ["10.0.0.0/16"]
}

variable "virtualnet" {
  type        = string
  description = "Virtual network name"
}

variable "subnet" {
  type        = string
  description = "Subnet name"
}

variable "addressprefix" {
  type        = list(string)
  description = "Default Address"
  default     = ["10.0.1.0/24"]
}