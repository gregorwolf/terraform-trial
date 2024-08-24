variable "subdomain" { type = string }
variable "subaccount_id" {
  type        = string
  description = "The subaccount ID."
}
variable "region" {
  type    = string
  default = "us10"
}

variable "cf_space_name" {
  type        = string
  description = "The name of the Cloud Foundry space."
  default     = "dev"
}

terraform {
  required_providers {
    btp = {
      source  = "SAP/btp"
      version = "~>1.5.0"
    }
    cloudfoundry = {
      source  = "SAP/cloudfoundry"
      version = "1.0.0-rc1"
    }
  }
}

provider "btp" {
  globalaccount = "${var.subdomain}-ga"
}

provider "cloudfoundry" {
  api_url = "https://api.cf.${var.region}-001.hana.ondemand.com"
}
