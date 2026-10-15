locals {
  employee_pool        = "10.8.0.0/22"
  admin_pool           = "10.8.4.0/24"
  pep_sensitivedata_ip = "192.168.14.4"
  pep_sql_ip           = "192.168.14.5"
  pep_webapp_ip        = "192.168.14.6"
  vpn_ip               = "192.168.1.5"

  vms = {
    proxy-01 = {
      subnet_id        = azurerm_subnet.snet_edge.id
      ip               = "192.168.1.4"
      pip_id           = azurerm_public_ip.pip_proxy.id
      ip_forwarding    = false
      has_asg          = true
      asg_id           = azurerm_application_security_group.asg_proxy.id
      size             = "Standard_B2s"
      managed_identity = false
      ansible_group    = "proxy"
    }
    vpn-01 = {
      subnet_id        = azurerm_subnet.snet_edge.id
      ip               = local.vpn_ip
      pip_id           = azurerm_public_ip.pip_vpn.id
      ip_forwarding    = true
      has_asg          = true
      asg_id           = azurerm_application_security_group.asg_vpn.id
      size             = "Standard_B2s"
      managed_identity = false
      ansible_group    = "vpn"
    }
    web-01 = {
      subnet_id        = azurerm_subnet.snet_frontend.id
      ip               = "192.168.4.4"
      pip_id           = null
      ip_forwarding    = false
      has_asg          = true
      asg_id           = azurerm_application_security_group.asg_portal.id
      size             = "Standard_B1s"
      managed_identity = true
      ansible_group    = "webservers"
    }
    web-02 = {
      subnet_id        = azurerm_subnet.snet_frontend.id
      ip               = "192.168.4.5"
      pip_id           = null
      ip_forwarding    = false
      has_asg          = true
      asg_id           = azurerm_application_security_group.asg_website.id
      size             = "Standard_B1s"
      managed_identity = false
      ansible_group    = "webservers"
    }
    media-01 = {
      subnet_id        = azurerm_subnet.snet_frontend.id
      ip               = "192.168.4.6"
      pip_id           = null
      ip_forwarding    = false
      has_asg          = true
      asg_id           = azurerm_application_security_group.asg_media.id
      size             = "Standard_B2s"
      managed_identity = false
      ansible_group    = "media"
    }
    ftp-01 = {
      subnet_id        = azurerm_subnet.snet_frontend.id
      ip               = "192.168.4.7"
      pip_id           = null
      ip_forwarding    = false
      has_asg          = true
      asg_id           = azurerm_application_security_group.asg_ftp.id
      size             = "Standard_B1s"
      managed_identity = false
      ansible_group    = "sftp"
    }
    app-01 = {
      subnet_id        = azurerm_subnet.snet_backend.id
      ip               = "192.168.8.4"
      pip_id           = null
      ip_forwarding    = false
      has_asg          = true
      asg_id           = azurerm_application_security_group.asg_app.id
      size             = "Standard_B1s"
      managed_identity = false
      ansible_group    = "appserver"
    }
    fs-01 = {
      subnet_id        = azurerm_subnet.snet_backend.id
      ip               = "192.168.8.5"
      pip_id           = null
      ip_forwarding    = false
      has_asg          = true
      asg_id           = azurerm_application_security_group.asg_fs.id
      size             = "Standard_B1s"
      managed_identity = false
      ansible_group    = "fileserver"
    }
    mgmt-01 = {
      subnet_id        = azurerm_subnet.snet_mgmt.id
      ip               = "192.168.13.4"
      pip_id           = null
      ip_forwarding    = false
      has_asg          = true
      asg_id           = azurerm_application_security_group.asg_mgmt.id
      size             = "Standard_B1s"
      managed_identity = true
      ansible_group    = "mgmt"
    }
    ids-01 = {
      subnet_id        = azurerm_subnet.snet_mgmt.id
      ip               = "192.168.13.5"
      pip_id           = null
      ip_forwarding    = false
      has_asg          = false
      asg_id           = null
      size             = "Standard_B2s"
      managed_identity = false
      ansible_group    = "ids"
    }
  }
}
