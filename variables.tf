variable "subdomain" { type = string }
variable "subaccount_id" {
  type        = string
  description = "The subaccount ID."
}

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

variable "hana_system_password" {
  type        = string
  description = "The password of the database 'superuser' DBADMIN."
  sensitive   = true

  # add validation to check if the password is at least 8 characters long
  validation {
    condition     = length(var.hana_system_password) > 7
    error_message = "The hana_system_password must be at least 8 characters long."
  }

  # add validation to check if the password contains at least one upper case
  validation {
    condition     = can(regex("[A-Z]", var.hana_system_password))
    error_message = "The hana_system_password must contain at least one upper case."
  }

  # add validation to check if the password contains at least two lower case characters
  validation {
    condition     = can(regex("[a-z]{2}", var.hana_system_password))
    error_message = "The hana_system_password must contain at least two lower case characters."
  }

  # add validation to check if the password contains at least one numeric character
  validation {
    condition     = can(regex("[0-9]", var.hana_system_password))
    error_message = "The hana_system_password must contain at least one numeric character."
  }
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
