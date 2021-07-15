variable "tenant_name" {
  type        = string
  description = "The name of our new Tenant managed by Terraform"
}

variable "vrfs" {
  type        = set(string)
  description = "List of VRFs we want our new tenant to have"
  default     = []
}

variable "bridge_domains" {
  type = map(object({
    routing = bool,
    vrf     = string,
  }))
  description = "Map of bridge domains to create and their associated VRFs"
  default     = {}
}

variable "application_profiles" {
  type        = set(string)
  description = "List of application profiles belonging to the Tenant"
  default     = []
}

variable "epgs" {
  type = map(object({
    application_profile = string,
    bridge_domain       = string,
    domains             = list(string),
    static_paths = list(object({
      path    = string,
      vlan_id = number,
    })),
  }))
  description = "Map of EPGs to create and their associated bridge-domains"
  default     = {}
}

locals {
  bds = tomap({
    for bd_key, bd in var.bridge_domains : bd_key => {
      vrf              = bd.vrf
      arp_flood        = bd.routing ? "no" : "yes"
      l2_unicast_flood = bd.routing ? "proxy" : "flood"
      route            = bd.routing ? "yes" : "no"
    }
  })
}

locals {
  tenant_name          = var.tenant_name
  vrfs                 = var.vrfs
  bridge_domains       = local.bds
  application_profiles = var.application_profiles
  epgs                 = var.epgs
}

locals {
  domain_list = flatten([
    for epg_key, epg in var.epgs : [
      for domain_key, domain in epg.domains : {
        domain = domain
        epg    = epg_key
      }
    ]
  ])
}

locals {
  domains = {
    for domain in local.domains : join(".", [domain.epg, domain.domain]) => domain
  }
}

locals {
  static_path_list = flatten([
    for epg_key, epg in var.epgs : [
      for path in epg.static_paths : {
        path  = path.path
        encap = "vlan-${path.vlan_id}"
        epg   = epg_key
      }
    ]
  ])
}

locals {
  static_paths = {
    for path in local.static_paths : join("/", [path.path, path.encap]) => path
  }
}