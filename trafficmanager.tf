######
# Create the Traffic Manager 
######

#Create randon ID
resource "random_id" "server" {
  keepers = {
    azi_id = 1
  }

  byte_length = 8
}
# Create the Traffic Manager Profile
resource "azurerm_traffic_manager_profile" "tmp" {
  name                   = random_id.server.hex
  resource_group_name    = azurerm_resource_group.azure-project.name
  traffic_routing_method = "Weighted"
  dns_config {
    relative_name = random_id.server.hex
    ttl           = 100
  }

# Create endpoint monitoring
  monitor_config {
    protocol                     = "HTTP"
    port                         = 80
    path                         = "/"
    interval_in_seconds          = 30
    timeout_in_seconds           = 10
    tolerated_number_of_failures = 3
  }

  #tags = local.tags
}

#Create Traffic Manager endpoints
resource "azurerm_traffic_manager_endpoint" "tm_ep" {
  name                = random_id.server.hex
  resource_group_name = azurerm_resource_group.azure-project.name
  profile_name        = azurerm_traffic_manager_profile.tmp.name
  type                = "azureEndpoints"
  target_resource_id  = azurerm_public_ip.pip.id
  weight           = 100
  depends_on = [azurerm_public_ip.pip]
}
