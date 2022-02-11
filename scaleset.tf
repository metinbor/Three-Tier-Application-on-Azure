
# Public IP for Load Balancer
resource "azurerm_public_ip" "pip" {
  name                = "pip-lb"
  location            = var.location
  resource_group_name = azurerm_resource_group.azure-project.name
  allocation_method   = "Static"
  domain_name_label   = "pip-lb"
}

resource "azurerm_lb" "lss" {
  name                = "lss-lb"
  location            = var.location
  resource_group_name = azurerm_resource_group.azure-project.name 

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.pip.id
  }
}

resource "azurerm_lb_backend_address_pool" "bpepool" {
  loadbalancer_id     = azurerm_lb.lss.id
  name                = "BackEndAddressPool"
}


resource "azurerm_lb_rule" "lbnatrule" {
   resource_group_name            = azurerm_resource_group.azure-project.name
   loadbalancer_id                = azurerm_lb.lss.id
   name                           = "http"
   protocol                       = "Tcp"
   frontend_port                  = "80"
   backend_port                   = "80"
   backend_address_pool_ids        = [azurerm_lb_backend_address_pool.bpepool.id]
   frontend_ip_configuration_name = "PublicIPAddress"
   probe_id                       = azurerm_lb_probe.lss.id
}

resource "azurerm_lb_probe" "lss" {
  resource_group_name = azurerm_resource_group.azure-project.name
  loadbalancer_id     = azurerm_lb.lss.id
  name                = "http-probe"
  protocol            = "tcp"
  port                = 80
}

# resource "azurerm_network_security_group" "nsg" {
#   name                = var.name
#   resource_group_name = azurerm_resource_group.azure-project.name
#   location            = var.location
# }

# resource "azurerm_network_security_rule" "nsg_rule" {
#   name                        = "http"
#   priority                    = 100
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   destination_port_range      = "80"
#   source_address_prefix       = "*"
#   destination_address_prefix  = "*"
#   resource_group_name         = azurerm_resource_group.azure-project.name
#   network_security_group_name = azurerm_network_security_group.nsg.name
#   depends_on                  = [azurerm_network_security_group.nsg]
# }

# resource "azurerm_network_security_rule" "nsg_rule1" {
#   name                        = "http1"
#   priority                    = 100
#   direction                   = "Outbound"
#   access                      = "Allow"
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   destination_port_range      = "80"
#   source_address_prefix       = "*"
#   destination_address_prefix  = "*"
#   resource_group_name         = azurerm_resource_group.azure-project.name
#   network_security_group_name = azurerm_network_security_group.nsg.name
#   depends_on                  = [azurerm_network_security_group.nsg]
# }

# Data template Bash bootstrapping file
# data "template_file" "script" {
#   template = file("user-data.sh")
    
# }

# data "template_cloudinit_config" "config" {
#   gzip          = true
#   base64_encode = true

#   part {
#     filename     = "user-data.sh"
#     content_type = "text/x-sh" 
#     content      = data.template_file.script.rendered
#   }

#   depends_on = [azurerm_mysql_server.wordpress]
# }


resource "azurerm_linux_virtual_machine_scale_set" "lss" {
  name                = "linuxscaleset"
  resource_group_name = azurerm_resource_group.azure-project.name
  location            = var.location
  sku                 = "Standard_DS1_v2"
  instances           = 2
  admin_username      = "adminuser"
  admin_password      = "p@ssword"
  # custom_data = base64encode(data.template_file.linux-vm-cloud-init.rendered)
  # custom_data = data.template_cloudinit_config.config.rendered
  custom_data = filebase64("user-data.sh")


  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  source_image_reference {
    publisher = "openlogic"
    offer     = "centOS"
    sku       = "7_9-gen2"
    version   = "7.9.2022012101"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "azurenetwork"
    primary = true
    # network_security_group_id     = azurerm_network_security_group.app-nsg.id

    ip_configuration {
      name      = "IPConfiguration"
      primary   = true
      subnet_id = azurerm_subnet.app-subnet.id  
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.bpepool.id]
      # load_balancer_inbound_nat_rules_ids = [azurerm_lb_nat_pool.lbnatpool.id]
      public_ip_address {
      name                = "pip-ss"

    }

    
    }  


    }
}
