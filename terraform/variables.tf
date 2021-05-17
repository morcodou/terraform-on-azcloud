variable "env" {
  default = "dev"
}

variable "backendrg-name" {
  type    = string
  default = "gmc-backend-rg"
}
variable "location-name" {
  type    = string
  default = "canadacentral"
}
variable "webvnet-name" {
  type    = string
  default = "gmc-web-vnet"
}
variable "websubnet-name" {
  type    = string
  default = "gmc-web-subnet"
}
variable "webnic-name" {
  type    = string
  default = "gmc-web-nic"
}
variable "webnsg-name" {
  type    = string
  default = "gmc-web-nsg"
}
variable "webwinvm-name" {
  type    = string
  default = "gmc-web-vm"
}
variable "admin-username" {
  type    = string
  default = "morcodou"
}
variable "admin-password" {
  type    = string
  default = "P@$$w0rd1234!"
  sensitive = true
}
