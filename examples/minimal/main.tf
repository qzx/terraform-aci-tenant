module "aci_tenant" {
  source  = "qzx/tenant/aci"
  version = "1.0.1"

  tenant_name = "example"
}