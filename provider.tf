terraform {
  required_providers {
    btp = {
      source  = "SAP/btp"
      version = "1.20.1"
    }
    cloudfoundry = {
      source  = "cloudfoundry/cloudfoundry"
      version = "1.13.0"
    }
    cis = {
      source  = "SAP/sap-cloud-identity-services"
      version = "0.4.0-beta1"
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

provider "cis" {
  tenant_url = "${var.cistenant_url}"
}
