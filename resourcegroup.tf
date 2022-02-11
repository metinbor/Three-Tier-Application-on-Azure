resource "azurerm_resource_group" "azure-project" {
  name     = var.name
  location = var.location
}