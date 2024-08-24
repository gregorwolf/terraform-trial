variable "subdomain" { type= string } 

terraform {
  required_providers {
    btp = {
      source  = "SAP/btp"
      version = "~>1.4.0"
    }
  }
}

provider "btp" {
  globalaccount = "${var.subdomain}-ga"
}
