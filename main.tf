terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.5"
    }
  }
}

provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
  subscription_id                 = "91760767-8ba3-4fab-9b01-fe9df3819f4b"
}

data "azurerm_resource_group" "rg" {
  name = "2026_KE06_KDB1_casusgroep_04"
}

locals {
  employee_pool        = "10.8.0.0/22"
  admin_pool           = "10.8.4.0/24"
  pep_sensitivedata_ip = "192.168.14.4"
  pep_sql_ip           = "192.168.14.5"
  pep_webapp_ip        = "192.168.14.6"
  vpn_ip               = "192.168.1.5"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-zkoo-01"
  address_space       = ["192.168.0.0/16"]
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "snet_edge" {
  name                 = "snet-edge"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["192.168.1.0/24"]
}

resource "azurerm_subnet" "snet_frontend" {
  name                 = "snet-frontend"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["192.168.4.0/22"]
}

resource "azurerm_subnet" "snet_backend" {
  name                 = "snet-backend"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["192.168.8.0/22"]
}

resource "azurerm_subnet" "snet_mgmt" {
  name                 = "snet-mgmt"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["192.168.13.0/28"]
}

resource "azurerm_subnet" "snet_pep" {
  name                              = "snet-pep"
  resource_group_name               = data.azurerm_resource_group.rg.name
  virtual_network_name              = azurerm_virtual_network.vnet.name
  address_prefixes                  = ["192.168.14.0/27"]
  private_endpoint_network_policies = "Enabled"
}

resource "azurerm_application_security_group" "asg_proxy" {
  name                = "asg-proxy"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_application_security_group" "asg_vpn" {
  name                = "asg-vpn"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_application_security_group" "asg_portal" {
  name                = "asg-portal"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_application_security_group" "asg_website" {
  name                = "asg-website"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_application_security_group" "asg_media" {
  name                = "asg-media"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_application_security_group" "asg_ftp" {
  name                = "asg-ftp"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_application_security_group" "asg_app" {
  name                = "asg-app"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_application_security_group" "asg_fs" {
  name                = "asg-fs"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_application_security_group" "asg_mgmt" {
  name                = "asg-mgmt"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_network_security_group" "nsg_edge" {
  name                = "nsg-edge"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  security_rule {
    name                                       = "allow-openvpn"
    priority                                   = 100
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "Udp"
    source_port_range                          = "*"
    destination_port_range                     = "1194"
    source_address_prefix                      = "Internet"
    destination_application_security_group_ids = [azurerm_application_security_group.asg_vpn.id]
  }

  security_rule {
    name                                       = "allow-https"
    priority                                   = 110
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "Tcp"
    source_port_range                          = "*"
    destination_port_range                     = "443"
    source_address_prefix                      = "Internet"
    destination_application_security_group_ids = [azurerm_application_security_group.asg_proxy.id]
  }

  security_rule {
    name                   = "allow-sftp-partners"
    priority               = 120
    direction              = "Inbound"
    access                 = "Allow"
    protocol               = "Tcp"
    source_port_range      = "*"
    destination_port_range = "22"
    # Deze reeks wordt later vervangen (TEST-NET-3), vervang met partner IP-ranges
    source_address_prefix                      = "203.0.113.0/24"
    destination_application_security_group_ids = [azurerm_application_security_group.asg_proxy.id]
  }

  security_rule {
    name                       = "deny-all-inbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_assoc_edge" {
  subnet_id                 = azurerm_subnet.snet_edge.id
  network_security_group_id = azurerm_network_security_group.nsg_edge.id
}

resource "azurerm_network_security_group" "nsg_frontend" {
  name                = "nsg-frontend"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  security_rule {
    name                                       = "allow-https-from-proxy"
    priority                                   = 100
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "Tcp"
    source_port_range                          = "*"
    destination_port_range                     = "443"
    source_application_security_group_ids      = [azurerm_application_security_group.asg_proxy.id]
    destination_application_security_group_ids = [azurerm_application_security_group.asg_portal.id, azurerm_application_security_group.asg_website.id]
  }

  security_rule {
    name                                       = "allow-media-from-proxy"
    priority                                   = 110
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "Tcp"
    source_port_range                          = "*"
    destination_port_range                     = "8096"
    source_application_security_group_ids      = [azurerm_application_security_group.asg_proxy.id]
    destination_application_security_group_ids = [azurerm_application_security_group.asg_media.id]
  }

  security_rule {
    name                                       = "allow-sftp-from-proxy"
    priority                                   = 120
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "Tcp"
    source_port_range                          = "*"
    destination_port_range                     = "22"
    source_application_security_group_ids      = [azurerm_application_security_group.asg_proxy.id]
    destination_application_security_group_ids = [azurerm_application_security_group.asg_ftp.id]
  }

  security_rule {
    name                                  = "allow-mgmt"
    priority                              = 130
    direction                             = "Inbound"
    access                                = "Allow"
    protocol                              = "Tcp"
    source_port_range                     = "*"
    destination_port_ranges               = ["3389", "22"]
    source_application_security_group_ids = [azurerm_application_security_group.asg_mgmt.id]
    destination_address_prefix            = azurerm_subnet.snet_frontend.address_prefixes[0]
  }

  security_rule {
    name                       = "deny-all-inbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_assoc_frontend" {
  subnet_id                 = azurerm_subnet.snet_frontend.id
  network_security_group_id = azurerm_network_security_group.nsg_frontend.id
}

resource "azurerm_network_security_group" "nsg_backend" {
  name                = "nsg-backend"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  security_rule {
    name                                       = "allow-app-from-employees"
    priority                                   = 100
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "Tcp"
    source_port_range                          = "*"
    destination_port_range                     = "443"
    source_address_prefix                      = local.employee_pool
    destination_application_security_group_ids = [azurerm_application_security_group.asg_app.id]
  }

  security_rule {
    name                                       = "allow-smb-from-employees"
    priority                                   = 110
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "Tcp"
    source_port_range                          = "*"
    destination_port_range                     = "445"
    source_address_prefix                      = local.employee_pool
    destination_application_security_group_ids = [azurerm_application_security_group.asg_fs.id]
  }

  security_rule {
    name                                  = "allow-mgmt"
    priority                              = 120
    direction                             = "Inbound"
    access                                = "Allow"
    protocol                              = "Tcp"
    source_port_range                     = "*"
    destination_port_ranges               = ["3389", "22"]
    source_application_security_group_ids = [azurerm_application_security_group.asg_mgmt.id]
    destination_address_prefix            = azurerm_subnet.snet_backend.address_prefixes[0]
  }

  security_rule {
    name                       = "deny-all-inbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_assoc_backend" {
  subnet_id                 = azurerm_subnet.snet_backend.id
  network_security_group_id = azurerm_network_security_group.nsg_backend.id
}

resource "azurerm_network_security_group" "nsg_mgmt" {
  name                = "nsg-mgmt"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  security_rule {
    name                                       = "allow-mgmt-from-admins"
    priority                                   = 100
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "Tcp"
    source_port_range                          = "*"
    destination_port_ranges                    = ["3389", "22"]
    source_address_prefix                      = local.admin_pool
    destination_application_security_group_ids = [azurerm_application_security_group.asg_mgmt.id]
  }

  security_rule {
    name                       = "deny-all-inbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_assoc_mgmt" {
  subnet_id                 = azurerm_subnet.snet_mgmt.id
  network_security_group_id = azurerm_network_security_group.nsg_mgmt.id
}

resource "azurerm_network_security_group" "nsg_pep" {
  name                = "nsg-pep"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  security_rule {
    name                                  = "allow-smb-from-portal"
    priority                              = 100
    direction                             = "Inbound"
    access                                = "Allow"
    protocol                              = "Tcp"
    source_port_range                     = "*"
    destination_port_range                = "445"
    source_application_security_group_ids = [azurerm_application_security_group.asg_portal.id]
    destination_address_prefix            = local.pep_sensitivedata_ip
  }

  security_rule {
    name                       = "allow-smb-from-employees"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "445"
    source_address_prefix      = local.employee_pool
    destination_address_prefix = local.pep_sensitivedata_ip
  }

  security_rule {
    name                                  = "allow-sql-from-portal"
    priority                              = 120
    direction                             = "Inbound"
    access                                = "Allow"
    protocol                              = "Tcp"
    source_port_range                     = "*"
    destination_port_range                = "1433"
    source_application_security_group_ids = [azurerm_application_security_group.asg_portal.id]
    destination_address_prefix            = local.pep_sql_ip
  }

  security_rule {
    name                                  = "allow-https-from-proxy"
    priority                              = 130
    direction                             = "Inbound"
    access                                = "Allow"
    protocol                              = "Tcp"
    source_port_range                     = "*"
    destination_port_range                = "443"
    source_application_security_group_ids = [azurerm_application_security_group.asg_proxy.id]
    destination_address_prefix            = local.pep_webapp_ip
  }

  security_rule {
    name                       = "deny-all-inbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_assoc_pep" {
  subnet_id                 = azurerm_subnet.snet_pep.id
  network_security_group_id = azurerm_network_security_group.nsg_pep.id
}

resource "azurerm_route_table" "rt_vpn" {
  name                = "rt-vpn"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  route {
    name                   = "to-employee-pool"
    address_prefix         = local.employee_pool
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = local.vpn_ip
  }

  route {
    name                   = "to-admin-pool"
    address_prefix         = local.admin_pool
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = local.vpn_ip
  }
}

resource "azurerm_subnet_route_table_association" "rt_assoc_backend" {
  subnet_id      = azurerm_subnet.snet_backend.id
  route_table_id = azurerm_route_table.rt_vpn.id
}

resource "azurerm_subnet_route_table_association" "rt_assoc_mgmt" {
  subnet_id      = azurerm_subnet.snet_mgmt.id
  route_table_id = azurerm_route_table.rt_vpn.id
}

resource "azurerm_subnet_route_table_association" "rt_assoc_pep" {
  subnet_id      = azurerm_subnet.snet_pep.id
  route_table_id = azurerm_route_table.rt_vpn.id
}