variable "resource_group_name"{
  default = "encryption group"
}
variable "managed_disk_name"{
  default = "encrypted-managed-disk"
}
variable "storage_account_type" {
  default = "encrypted-storage-type"
}
variable "create_option" {
  default = "create_option"
}
variable "source_uri" {
  default = "source_uri"
}
variable "source_resource_id" {
  default = "source_resource_id"
}
variable "image_reference_id" {
  default = "image_reference_id"
}
variable "disk_size_gb" {
    default = "disk_size_gb"
}
variable "keyvaultname" {
  default = "terra-key-vault"
}
variable "keyvalutskuname" {
  default = "key-SKU"
}
variable "storage-name" {
  type = "string"
  default = "storage-name"
}
variable "container-name" {
  type = "string"
  default = "container-name"
}
variable "blob-name" {
  default = "blob-name1"
}
variable "location" {
  default = "westus"
}