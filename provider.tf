terraform {
  required_providers {
    btp = {
      source  = "SAP/btp"
      version = "~>1.11.0"
    }
    cloudfoundry = {
      source  = "cloudfoundry/cloudfoundry"
      version = "~>1.5.0"
    }
  }
}

provider "btp" {
  globalaccount = "${var.subdomain}-ga"
}

provider "cloudfoundry" {
  api_url = "https://api.cf.${var.region}${var.extLandscape}.hana.ondemand.com"
}
