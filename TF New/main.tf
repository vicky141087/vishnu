provider "azurerm" {
  version = "=1.28.0"
}

data "azurerm_resource_group" "res-grp" {
  name = "my-group"
  location = "West US 2"
}

resource "azurerm_key_vault" "terrakeyvault" {
  name           = "my-keyvault"
  location       = "West US 2"
  sku {
    name = "my-sku-keyvault"
  }
}

resource "azurerm_managed_disk" "disk" {
  name            = "my-disk"
  location            = "West US 2"
  storage_account_type= "Standard_LRS"
  create_option       = "Empty"
  resource_group_name = "${data.azurerm_resource_group.res-grp.name}"
  disk_size_gb        = "1"

  encryption_settings {
    enabled           = true

    key_encryption_key {
      key_url         = "${azurerm_key_vault.terrakeyvault.vault_uri}"
      source_vault_id = "${azurerm_key_vault.terrakeyvault.id}"
    }
  }
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "my-storageAccount"
  resource_group_name      = "${data.azurerm_resource_group.res-grp.name}"
  location                 = "West US 2"
  account_tier             = "Standard"
    account_replication_type = "LRS"
}

resource "azurerm_storage_container" "storage_container" {
  name         = "my-storageContainer"
  resource_group_name   = "${data.azurerm_resource_group.res-grp.name}"
  storage_account_name  = "${azurerm_storage_account.storage_account.name}"
  container_access_type = "private"
  location = "West US 2"
}

resource "azurerm_storage_blob" "blob_storage" {
  name           = "my-blobstorage"
  resource_group_name    = "${data.azurerm_resource_group.res-grp.name}"
  storage_account_name   = "${azurerm_storage_account.storage_account.name}"
  storage_container_name = "${azurerm_storage_account.storage_container.name}"
  location            = "West US 2"
  type = "page"
  size = 5120
  
  encryption_settings {
    enabled           = true

    key_encryption_key {
      key_url         = "${azurerm_key_vault.terrakeyvault.vault_uri}"
      source_vault_id = "${azurerm_key_vault.terrakeyvault.id}"
    }
  }
}