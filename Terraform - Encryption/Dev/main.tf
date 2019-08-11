provider "azurerm" {
  version = "=1.32.0"
}

data "azurerm_resource_group" "res-grp" {
  name = "${var.resource_group_name}"
  location = "${var.location}"
}

module "terrakeyvault" {
  source = "../Modules/Module key vault"
  name = "${lower(var.keyvaultname)}"
  location = "${coalesce(var.location, data.azurerm_resource_group.res-grp.location)}"

  sku {
    name = "${var.keyvalutskuname}"
  }
}

module "disk" {
  source = "../Modules/Module - Managed disk"
  name = "${var.managed_disk_name}"

  location = "${coalesce(var.location, data.azurerm_resource_group.res-grp.location)}"

  storage_account_type = "${var.storage_account_type}"
  create_option       = "${local.create_option}"
  source_uri          = "${var.source_uri}"
  source_resource_id  = "${var.source_resource_id}"
  image_reference_id  = "${var.image_reference_id}"
  disk_size_gb        = "${var.disk_size_gb}"

  encryption_settings {
    enabled           = true

    key_encryption_key {
      key_url         = "${terrakeyvault.TerraKeyVault.vault_uri}"
      source_vault_id = "${terrakeyvault.TerraKeyVault.id}"
    }
  }
}

module "storageAccount" {
  source = "../Modules/Module - Blob Storage"
  name                     = "${var.storage-name}"
  resource_group_name      = "${data.azurerm_resource_group.res-grp.name}"
  location                 = "${coalesce(var.location, data.azurerm_resource_group.res-grp.location)}"
  account_tier             = "Standard"
    account_replication_type = "LRS"
}

module "storageContainer" {
  source = "../Modules/Module - Blob Storage"
  name         = "${var.container-name}"
  resource_group_name   = "${data.azurerm_resource_group.res-grp.name}"
  storage_account_name  = "${module.storageAccount.name}"
  container_access_type = "private"
  location = "${coalesce(var.location, data.azurerm_resource_group.res-grp.location)}"
}

module "blobStorage" {
  source = "../Modules/Module - Blob Storage"
  name           = "${var.blob-name}"
  resource_group_name    = "${data.azurerm_resource_group.res-grp.name}"
  storage_account_name   = "${module.storageAccount.name}"
  storage_container_name = "${module.storageContainer.name}"
  location            = "${coalesce(var.location, data.azurerm_resource_group.res-grp.location)}"
  type = "page"
  size = 5120
  
  encryption_settings {
    enabled           = true

    key_encryption_key {
      key_url         = "${terrakeyvault.TerraKeyVault.vault_uri}"
      source_vault_id = "${terrakeyvault.TerraKeyVault.id}"
    }
  }
}