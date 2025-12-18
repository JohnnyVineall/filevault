variable "resource_group_name" {
  default = "FilevaultJohnnyTF"
}

variable "location" {
  default = "uksouth"
}

variable "acr_password" {
  type      = string
  sensitive = true
}