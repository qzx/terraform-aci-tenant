module "aci_tenant" {
  source  = "qzx/tenant/aci"
  version = "0.1.2"

  tenant_name = "example"
}