/**
 * # terraform-aci-tenant
 * 
 * Terraform module to set up a ACI tenant with VRFs, BridgeDomains and EPGS
 * Supports vmm_domain mapping, for static vlan mapping refer to supporting module
 *  terraform-aci-static-vlan
 * 
 */

terraform {
  required_providers {
    aci = {
      source  = "CiscoDevNet/aci"
      version = "~> 0.7.0"
    }
  }
}

resource "aci_tenant" "this" {
  name = local.tenant_name
}

resource "aci_vrf" "this" {
  for_each  = local.vrfs
  name      = each.key
  tenant_dn = aci_tenant.this.id
}

resource "aci_bridge_domain" "this" {
  for_each = local.bridge_domains

  name               = each.value.name
  tenant_dn          = aci_tenant.this.id
  relation_fv_rs_ctx = aci_vrf.this[each.value.vrf].id
}

resource "aci_application_profile" "this" {
  for_each = local.application_profiles

  name      = each.key
  tenant_dn = aci_tenant.this.id
}

resource "aci_application_epg" "this" {
  for_each = local.epgs
  name     = each.value.name

  application_profile_dn = aci_application_profile.this[each.value.application_profile].id

  relation_fv_rs_bd = aci_bridge_domain.this[each.value.bridge_domain].id
}

resource "aci_epg_to_domain" "this" {
  for_each = {
    for domain in local.domains : "${domain.epg}.${domain.domain}" => domain
  }

  application_epg_dn = aci_application_epg.this[each.value.epg].id
  tdn                = each.value.domain
}