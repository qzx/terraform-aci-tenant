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
 * ```hcl
 * module "aci_tenant" {
 *   source   = "qzx/tenant/aci"
 *   version  = "0.1.2"
 * 
 *   tenant_name          = "MY_TENANT"
 *   vrfs                 = ["MY_VRF1", "MY_VRF2"]
 *   bridge_domains       = {
 *     BD1 = {
 *       routing = true
 *       vrf     = "MY_VRF1"
 *     },
 *     BD2 = {
 *       routing = false
 *       vrf     = "MY_VRF2"
 *     }
 *   }
 *   application_profiles = ["ONE", "TWO"]
 *   epgs                 = {
 *     EPG1 = {
 *       application_profile = "ONE"
 *       bridge_domain       = "BD1"
 *       domains             = ["uni/phys-MY_PHYSICAL_DOMAIN"]
 *       static_paths        = []
 *     },
 *     EPG2 = {
 *       application_profile = "TWO"
 *       bridge_domain       = "BD2"
 *       domains             = ["uni/phys-MY_PHYSICAL_DOMAIN"]
 *       static_paths        = [
 *         {
 *           vlan_id = 100
 *           path    = "topology/pod-1/protpaths-201-202/pathep-[MY_VPC_PATH_A]"
 *         },
 *         {
 *           vlan_id = 100
 *           path    = "topology/pod-1/protpaths-201-202/pathep-[MY_VPC_PATH_B]"
 *         }
 *       ]
 *     }
 *   }
 * }
 * ```
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

  name                   = each.key
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