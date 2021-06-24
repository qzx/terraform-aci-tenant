output "name" {
  description = "The name of the tenant we just created"
  value       = aci_tenant.this.name
}

output "vrf" {
  description = "The name of the tenant we just created"
  value       = aci_vrf.this
}

output "ap" {
  description = "The name of the tenant we just created"
  value       = aci_application_profile.this
}