variable "managed_disk_name"{
  description = "this is name for managed disk."
}
variable "storage_account_type" {
  description = "this is name  managed disk storage type."
}
variable "create_option" {
  description = "this is the create option for managed disk."
}
variable "source_uri" {
  description = "this is the source uri."
}
variable "source_resource_id" {
  description = "this is the source resource id for managed disk."
}
variable "image_reference_id" {
  description = "this is the image reference id for managed disk."
}
variable "disk_size_gb" {
  description = "this is the disk size for managed disk."
}
variable "location" {
  description = "this is the location where managed disk will be created."
}