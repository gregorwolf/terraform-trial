terraform {
  required_providers {
    btp = {
      source  = "SAP/btp"
      version = "~>1.4.0"
    }
  }
}

provider "btp" {
  globalaccount = "b47e9479trial-ga"
}
