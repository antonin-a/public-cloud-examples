resource "openstack_networking_network_v2" "mononetwork" {
  for_each = { for o in var.multi : o.region => o }

  name           = var.common.monoNwName
  region         = each.key
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "monosubnet" {
  for_each = { for o in var.multi : o.region => o }

  network_id      = openstack_networking_network_v2.mononetwork[each.key].id
  name            = var.common.monoSubnetName
  region          = each.key
  cidr            = each.value.monoSubnetCIDR
  enable_dhcp     = false
  no_gateway      = false
  dns_nameservers = ["1.1.1.1", "1.0.0.1"]
}

resource "openstack_networking_router_v2" "router" {
  for_each = { for o in var.multi : o.region => o }

  region              = each.key
  name                = var.common.routerName
  admin_state_up      = true
  external_network_id = data.openstack_networking_network_v2.Ext-Net[each.key].id
}

resource "openstack_networking_router_interface_v2" "routerInterface" {
  for_each = { for o in var.multi : o.region => o }

  region    = each.key
  router_id = openstack_networking_router_v2.router[each.key].id
  subnet_id = openstack_networking_subnet_v2.monosubnet[each.key].id
}

resource "ovh_cloud_project_network_private" "multinetwork" {
  service_name = var.serviceName
  name         = var.common.multiNwName
  vlan_id      = var.common.multiNwVlanId
  regions      = var.common.regions
}

resource "openstack_networking_subnet_v2" "multisubnet" {
  for_each = { for o in var.multi : o.region => o }

  network_id  = tolist(ovh_cloud_project_network_private.multinetwork.regions_attributes)[index(ovh_cloud_project_network_private.multinetwork.regions_attributes.*.region, each.key)].openstackid
  region      = each.key
  cidr        = var.common.multiSubnetCIDR
  enable_dhcp = false
  gateway_ip  = each.value.routerMultiNwIP
  allocation_pool {
    start = each.value.multiSubnetStart
    end   = each.value.multiSubnetEnd
  }
}
