provider "azurerm" {
  version = "=1.32.0"
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "${var.storage-name}"
  location                 = "${var.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "storage_container" {
  name                  = "${var.container-name}"
  storage_account_name  = "${azurerm_storage_account.storage_account.name}"
  container_access_type = "private"
  location = "${var.location}"
}

resource "azurerm_storage_blob" "blob_storage" {
  name                   = "${var.blob-name}"
  storage_account_name   = "${azurerm_storage_account.storage_account.name}"
  storage_container_name = "${azurerm_storage_container.storage_container.name}"
  location               = "${var.location}"
  type = "page"
  size = 5120
}