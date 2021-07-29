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
      application_profile = "ONE"
      bridge_domain       = "BD1"
      domains             = ["uni/phys-MY_PHYSICAL_DOMAIN"]
      static_paths        = []
    },
    EPG2 = {
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