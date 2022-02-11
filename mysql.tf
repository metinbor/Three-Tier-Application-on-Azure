# Create MySQL Server

resource "azurerm_mysql_server" "wordpress" {
    name = "project-wp-mysqlserver"
    resource_group_name = azurerm_resource_group.azure-project.name
    location = var.location
    version = "5.7"

    administrator_login = "wordpress"
    administrator_login_password = "w0rdpr3ss@p4ss"

    sku_name                     = "B_Gen5_2"
    storage_mb                   = "5120"
    auto_grow_enabled            = false
    backup_retention_days        = 7
    geo_redundant_backup_enabled = false

    infrastructure_encryption_enabled = false
    public_network_access_enabled     = true
    ssl_enforcement_enabled           = false

}
# resource "azurerm_mysql_virtual_network_rule" "wordpress" {
#   name                = "mysql-vnet-rule"
#   resource_group_name = azurerm_resource_group.azure-project.name
#   server_name         = azurerm_mysql_server.wordpress.name
#   subnet_id           = azurerm_subnet.db-subnet.id
# }

# resource "azurerm_mysql_firewall_rule" "wordpress" {
#   name                = "wordpress-mysql-firewall-rule"
#   resource_group_name = azurerm_resource_group.azure-project.name
#   server_name         = azurerm_mysql_server.wordpress.name
#   start_ip_address    = azurerm_public_ip.pip.ip_address
#   end_ip_address      = azurerm_public_ip.pip.ip_address
# }

# Create MySql DataBase

resource "azurerm_mysql_database" "wordpress" {
  name                = "wordpress-db"
  resource_group_name = azurerm_resource_group.azure-project.name
  server_name         = azurerm_mysql_server.wordpress.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}



data "azurerm_mysql_server" "wordpress" {
  name                = azurerm_mysql_server.wordpress.name
  resource_group_name = azurerm_resource_group.azure-project.name
}