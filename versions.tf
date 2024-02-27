terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aci = {
      source  = "CiscoDevNet/aci"
      version = "~> 0.7.0"
    }
  }
}