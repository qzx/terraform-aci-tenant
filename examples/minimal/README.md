<!-- BEGIN_TF_DOCS -->
# Minimal tenant example, just create a tenant
To run this example you need to execute:
```bash
$ terraform init
$ terraform plan
$ terraform apply
```
Note that this example will create resources. Resources can be destroyed with `terraform destroy`.
```hcl
module "aci_tenant" {
  source  = "qzx/tenant/aci"
  version = "1.0.1"

  tenant_name = "example"
}
```
<!-- END_TF_DOCS -->