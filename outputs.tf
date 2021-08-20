output "epgs" {
  description = "List of EPGs created"
  value = [
    for epg in aci_application_epg.this : epg.id
  ]
}

output "tenant_dn" {
  description = "Name of the Tenant created"
  value       = aci_tenant.this.id
}

output "vrfs" {
  description = "List of VRFs created"
  value       = aci_vrf.this
}