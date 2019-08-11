provider "azurerm" {
  #version = "=1.32.0"
}

resource "azurerm_key_vault" "terrakeyvault" {
  name           = "${lower(var.keyvaultname)}"
  location            = "${var.location}"
  sku {
    name = "${var.keyvalutskuname}"
  }
}