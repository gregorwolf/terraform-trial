terraform {
  required_providers {
    btp = {
      source  = "SAP/btp"
      version = "1.15.1"
    }
    cloudfoundry = {
      source  = "cloudfoundry/cloudfoundry"
      version = "1.8.0"
    }
  }
}

provider "btp" {
  globalaccount = "${var.subdomain}-ga"
}

provider "cloudfoundry" {
  api_url  = "https://api.cf.${var.region}${var.extLandscape}.hana.ondemand.com"
  user     = var.cf_user
  password = var.cf_password
}
