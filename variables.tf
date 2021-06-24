variable "tenant_name" {
  type        = string
  description = "The name of our new Tenant managed by Terraform"
}

variable "vrfs" {
  type        = set(string)
  description = "The name of our new Tenant managed by Terraform"
}

variable "bridge_domains" {
  type = map(object({
    name    = string,
    routing = string,
    vrf     = string,
  }))
  description = "Map of bridge domains to create and their associated VRFs"
}

variable "application_profiles" {
  type        = set(string)
  description = "List of application profiles belonging to the Tenant"
}

variable "epgs" {
  type = map(object({
    name                = string,
    application_profile = string,
    bridge_domain       = string,
    domains             = list(string),
  }))
  description = "Map of EPGs to create and their associated bridge-domains"
}

locals {
  tenant_name          = var.tenant_name
  vrfs                 = var.vrfs
  bridge_domains       = var.bridge_domains
  application_profiles = var.application_profiles
  epgs                 = var.epgs
}

locals {
  domains = flatten([
    for epg_key, epg in var.epgs : [
      for domain_key, domain in epg.domains : {
        domain = domain
        epg    = epg_key
      }
    ]
  ])
}