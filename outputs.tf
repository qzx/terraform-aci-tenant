output "epgs" {
  description = "List of EPGs created"
  value = [
    for epg in aci_application_epg.this : epg.id
  ]
}

