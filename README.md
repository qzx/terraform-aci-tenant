## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aci_application_epg.this](https://registry.terraform.io/providers/hashicorp/aci/latest/docs/resources/application_epg) | resource |
| [aci_application_profile.this](https://registry.terraform.io/providers/hashicorp/aci/latest/docs/resources/application_profile) | resource |
| [aci_bridge_domain.this](https://registry.terraform.io/providers/hashicorp/aci/latest/docs/resources/bridge_domain) | resource |
| [aci_tenant.this](https://registry.terraform.io/providers/hashicorp/aci/latest/docs/resources/tenant) | resource |
| [aci_vrf.this](https://registry.terraform.io/providers/hashicorp/aci/latest/docs/resources/vrf) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_profiles"></a> [application\_profiles](#input\_application\_profiles) | List of application profiles belonging to the Tenant | `list(any)` | n/a | yes |
| <a name="input_bridge_domains"></a> [bridge\_domains](#input\_bridge\_domains) | List of bridge domains to create and their associated VRFs | `map(any)` | n/a | yes |
| <a name="input_epgs"></a> [epgs](#input\_epgs) | List of EPGs to create and their associated bridge-domains | `map(any)` | n/a | yes |
| <a name="input_tenant_name"></a> [tenant\_name](#input\_tenant\_name) | The name of our new Tenant managed by Terraform | `string` | n/a | yes |
| <a name="input_vrfs"></a> [vrfs](#input\_vrfs) | The name of our new Tenant managed by Terraform | `list(any)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_name"></a> [name](#output\_name) | The name of the tenant we just created |