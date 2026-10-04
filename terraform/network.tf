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

resource "azurerm_public_ip" "pip_proxy" {
  name                = "pip-proxy-01"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_public_ip" "pip_vpn" {
  name                = "pip-vpn-01"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
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
