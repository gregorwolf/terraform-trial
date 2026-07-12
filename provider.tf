terraform {
  required_providers {
    btp = {
      source  = "SAP/btp"
      version = "1.24.0"
    }
    cloudfoundry = {
      source  = "cloudfoundry/cloudfoundry"
      version = "1.16.0"
    }
    sci = {
      source  = "SAP/sap-cloud-identity-services"
      version = "0.6.0-beta1"
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

provider "sci" {
  tenant_url = var.cistenant_url
  username   = var.ias_client_id
  password   = var.ias_client_secret
}
