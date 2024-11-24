terraform {
  required_providers {
    btp = {
      source  = "SAP/btp"
      version = "~>1.8.0"
    }
    cloudfoundry = {
      source  = "SAP/cloudfoundry"
      version = "1.0.0-rc1.depr"
    }
  }
}

provider "btp" {
  globalaccount = "${var.subdomain}-ga"
}

provider "cloudfoundry" {
  api_url = "https://api.cf.${var.region}${var.extLandscape}.hana.ondemand.com"
}
