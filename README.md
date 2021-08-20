<!-- BEGIN_TF_DOCS -->
[![published](https://static.production.devnetcloud.com/codeexchange/assets/images/devnet-published.svg)](https://developer.cisco.com/codeexchange/github/repo/qzx/terraform-aci-tenant)
# Terraform ACI Tenant Module
Manages ACI Tenant
Location in GUI:
`Tenants`
## Examples

### Minimal Tenant config
```hcl
module "aci_tenant" {
  source  = "qzx/tenant/aci"
  version = "1.0.0"

  tenant_name = "example"
}
```

### Tenant config with VRFs, BDs, AP, EPG and static path mapping
```hcl
module "aci_tenant" {
  source  = "qzx/tenant/aci"
  version = "1.0.0"

  tenant_name = "example"
  vrfs        = ["MY_VRF1", "MY_VRF2"]
  bridge_domains = {
    BD1 = {
      routing = true
      vrf     = "MY_VRF1"
    },
    BD2 = {
      routing = false
      vrf     = "MY_VRF2"
    }
  }
  application_profiles = ["ONE", "TWO"]
  epgs = {
    EPG1 = {
      name                = "EPG1"
      application_profile = "ONE"
      bridge_domain       = "BD1"
      domains             = ["uni/phys-MY_PHYSICAL_DOMAIN"]
      static_paths        = []
    },
    TWO-EPG2 = {
      name                = "EPG2"
      application_profile = "TWO"
      bridge_domain       = "BD2"
      domains             = ["uni/phys-MY_PHYSICAL_DOMAIN"]
      static_paths = [
        {
          vlan_id = 100
          path    = "topology/pod-1/protpaths-201-202/pathep-[MY_VPC_PATH_A]"
        },
        {
          vlan_id = 100
          path    = "topology/pod-1/protpaths-201-202/pathep-[MY_VPC_PATH_B]"
        }
      ]
    }
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | ~> 0.7.0 |
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | ~> 0.7.0 |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_tenant_name"></a> [tenant\_name](#input\_tenant\_name) | The name of our new Tenant managed by Terraform | `string` | n/a | yes |
| <a name="input_vrfs"></a> [vrfs](#input\_vrfs) | List of VRFs we want our new tenant to have | `set(string)` | `[]` | no |
| <a name="input_bridge_domains"></a> [bridge\_domains](#input\_bridge\_domains) | Map of bridge domains to create and their associated VRFs | <pre>map(object({<br>    routing = bool,<br>    vrf     = string,<br>  }))</pre> | `{}` | no |
| <a name="input_application_profiles"></a> [application\_profiles](#input\_application\_profiles) | List of application profiles belonging to the Tenant | `set(string)` | `[]` | no |
| <a name="input_epgs"></a> [epgs](#input\_epgs) | Map of EPGs to create and their associated bridge-domains | <pre>map(object({<br>    name                = string,<br>    application_profile = string,<br>    bridge_domain       = string,<br>    domains             = list(string),<br>    static_paths = list(object({<br>      path    = string,<br>      vlan_id = number,<br>    })),<br>  }))</pre> | `{}` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_epgs"></a> [epgs](#output\_epgs) | List of EPGs created |
| <a name="output_tenant_dn"></a> [tenant\_dn](#output\_tenant\_dn) | Name of the Tenant created |
| <a name="output_vrfs"></a> [vrfs](#output\_vrfs) | List of VRFs created |
## Resources

| Name | Type |
|------|------|
| [aci_application_epg.this](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/application_epg) | resource |
| [aci_application_profile.this](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/application_profile) | resource |
| [aci_bridge_domain.this](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/bridge_domain) | resource |
| [aci_epg_to_domain.this](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/epg_to_domain) | resource |
| [aci_epg_to_static_path.this](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/epg_to_static_path) | resource |
| [aci_tenant.this](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/tenant) | resource |
| [aci_vrf.this](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/vrf) | resource |
<!-- END_TF_DOCS -->