/**
 * # terraform-aci-tenant
 * 
 * Terraform module to set up a ACI tenant with VRFs, BridgeDomains and EPGS
 * Supports vmm_domain mapping as well as physical domain and static path
 * 
 * # Example
 *
 * ## Note: Keys in bridge_domains and epgs maps are the names of the respective BD or EPG
 * 
*/

resource "aci_tenant" "this" {
  name = local.tenant_name
}

resource "aci_vrf" "this" {
  for_each   = local.vrfs
  name       = each.key
  tenant_dn  = aci_tenant.this.id
  depends_on = [aci_tenant.this]
}

resource "aci_bridge_domain" "this" {
  for_each = local.bridge_domains

  name                      = each.key
  tenant_dn                 = aci_tenant.this.id
  unicast_route             = each.value.route
  arp_flood                 = each.value.arp_flood
  unk_mac_ucast_act         = each.value.l2_unicast_flood
  limit_ip_learn_to_subnets = "yes"
  relation_fv_rs_ctx        = aci_vrf.this[each.value.vrf].id
  depends_on                = [aci_vrf.this]
}

resource "aci_application_profile" "this" {
  for_each = local.application_profiles

  name       = each.key
  tenant_dn  = aci_tenant.this.id
  depends_on = [aci_tenant.this]
}

resource "aci_application_epg" "this" {
  for_each = local.epgs

  name                   = each.value.name
  application_profile_dn = aci_application_profile.this[each.value.application_profile].id
  relation_fv_rs_bd      = aci_bridge_domain.this[each.value.bridge_domain].id
  depends_on             = [aci_bridge_domain.this, aci_application_profile.this]
}

resource "aci_epg_to_domain" "this" {
  for_each = local.domains

  application_epg_dn = aci_application_epg.this[each.value.epg].id
  tdn                = each.value.domain
  depends_on         = [aci_application_epg.this]
}


resource "aci_epg_to_static_path" "this" {
  for_each = local.static_paths

  application_epg_dn = aci_application_epg.this[each.value.epg].id
  tdn                = each.value.path
  encap              = each.value.encap
  mode               = "regular"
  depends_on         = [aci_application_epg.this, aci_epg_to_domain.this]
}