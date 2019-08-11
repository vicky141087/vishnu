provider "azurerm" {
  version = "=1.28.0"
}

resource "azurerm_resource_group" "res-grp" {
  name = "my-group"
  location = "West US 2"
}

resource "azurerm_key_vault" "terrakeyvault" {
  name           = "my-keyvault"
  location       = "West US 2"
  tenant_id		 = "189de737-c93a-4f5a-8b68-6f4ca9941912"
  resource_group_name = "${azurerm_resource_group.res-grp.name}"
  
  sku {
    name = "standard"
  }
}

resource "azurerm_managed_disk" "disk" {
  name            = "my-disk"
  location            = "West US 2"
  storage_account_type= "Standard_LRS"
  create_option       = "Empty"
  resource_group_name = "${azurerm_resource_group.res-grp.name}"
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
  name                     = "mystorageaccount"
  resource_group_name      = "${azurerm_resource_group.res-grp.name}"
  location                 = "West US 2"
  account_tier             = "Standard"
    account_replication_type = "LRS"
}

resource "azurerm_storage_container" "storage_container" {
  name         = "mystoragecontainer"
  resource_group_name   = "${azurerm_resource_group.res-grp.name}"
  storage_account_name  = "${azurerm_storage_account.storage_account.name}"
  container_access_type = "private"
}

resource "azurerm_storage_blob" "blob_storage" {
  name           = "myblobstorage"
  resource_group_name    = "${azurerm_resource_group.res-grp.name}"
  storage_account_name   = "${azurerm_storage_account.storage_account.name}"
  storage_container_name = "${azurerm_storage_container.storage_container.name}"
  type = "page"
  size = 5120
}