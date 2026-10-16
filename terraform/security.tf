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
    destination_port_range = "2222"
    # Deze reeks wordt later vervangen (TEST-NET-3), vervang met partner IP-ranges
    source_address_prefixes                    = var.partner_ip_ranges
    destination_application_security_group_ids = [azurerm_application_security_group.asg_proxy.id]
  }

  security_rule {
    name                                  = "allow-mgmt"
    priority                              = 130
    direction                             = "Inbound"
    access                                = "Allow"
    protocol                              = "Tcp"
    source_port_range                     = "*"
    destination_port_range                = "22"
    source_application_security_group_ids = [azurerm_application_security_group.asg_mgmt.id]
    destination_address_prefix            = azurerm_subnet.snet_edge.address_prefixes[0]
  }

  # Forwarded traffic from VPN clients: sources are outside the VirtualNetwork tag
  # for snet-edge (no UDR there), so the default AllowVnetOutBound does not match
  security_rule {
    name                       = "allow-vpn-clients-to-vnet"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefixes    = [local.admin_pool, local.employee_pool]
    destination_address_prefix = "VirtualNetwork"
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
    destination_port_range                = "22"
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
    destination_port_range                = "22"
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
    destination_port_range                     = "22"
    source_address_prefix                      = local.admin_pool
    destination_application_security_group_ids = [azurerm_application_security_group.asg_mgmt.id]
  }

  security_rule {
    name                                  = "allow-ssh-mgmt"
    priority                              = 110
    direction                             = "Inbound"
    access                                = "Allow"
    protocol                              = "Tcp"
    source_port_range                     = "*"
    destination_port_range                = "22"
    source_application_security_group_ids = [azurerm_application_security_group.asg_mgmt.id]
    destination_address_prefix            = local.vms["ids-01"].ip
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
