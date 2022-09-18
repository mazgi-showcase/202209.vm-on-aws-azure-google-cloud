terraform {
  backend "azurerm" {
    container_name = "provisioning"
    key            = "default/terraform"
  }
}
