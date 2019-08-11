provider "azurerm" {
  version = "=1.32.0"
}

resource "azurerm_managed_disk" "disk" {
  name            = "${var.managed_disk_name}"
  location            = "${var.location}"
  storage_account_type= "${var.storage_account_type}"
  create_option       = "${local.create_option}"
  source_uri          = "${var.source_uri}"
  source_resource_id  = "${var.source_resource_id}"
  image_reference_id  = "${var.image_reference_id}"
  disk_size_gb        = "${var.disk_size_gb}"
}