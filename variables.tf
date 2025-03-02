variable "subdomain" { type = string }

variable "region" {
  type    = string
  default = "us10"
}

variable "extLandscape" {
  type    = string
  default = "-001"
}

variable "cf_space_name" {
  type        = string
  description = "The name of the Cloud Foundry space."
  default     = "dev"
}

variable "cf_organization_guid" {
  type        = string
  description = "The GUID of the Cloud Foundry organization."
}

variable "cf_space_guid" {
  type        = string
  description = "The GUID of the Cloud Foundry space."
}

variable "hana_appname" {
  type        = string
  description = "HANA Cloud appName"
  default     = "hana-cloud-tools-trial"
}

variable "hana_service_name" {
  type        = string
  description = "HANA Cloud service_name"
  default     = "hana-cloud-trial"
}

variable "hana_memory" {
  type        = number
  description = "HANA Cloud Memory"
  default     = 16
}
variable "admins" {
  type        = list(string)
  description = "Defines the colleagues who are added to each subaccount as emergency administrators."

  # add validation to check if admins contains a list of valid email addresses
  validation {
    condition     = length([for email in var.admins : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.admins)
    error_message = "Please enter a valid email address for the admins."
  }
}
