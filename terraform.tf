terraform {
  cloud {

    organization = "ComputerserviceWolf"

    workspaces {
      name = "btp-trial"
    }
  }
}
