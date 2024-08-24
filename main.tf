resource "btp_subaccount" "trial" {
  name      = "trial"
  subdomain = var.subdomain
  region    = var.region
}
## Uncomment for the import
# import {
#   to = btp_subaccount.trial
#   id = var.subaccount_id
# }

resource "btp_subaccount_entitlement" "alert_notification_service" {
  subaccount_id = btp_subaccount.trial.id
  service_name  = "alert-notification"
  plan_name     = "standard"
}


resource "btp_subaccount_entitlement" "identity_service" {
  subaccount_id = btp_subaccount.trial.id
  service_name  = "sap-identity-services-onboarding"
  plan_name     = "default"
}

resource "btp_subaccount_entitlement" "SAPLaunchpad" {
  subaccount_id = btp_subaccount.trial.id
  service_name  = "SAPLaunchpad"
  plan_name     = "standard"
}

resource "btp_subaccount_subscription" "build_workzone_subscribe" {
  subaccount_id = btp_subaccount.trial.id
  app_name      = "SAPLaunchpad"
  plan_name     = "standard"
  depends_on    = [btp_subaccount_entitlement.SAPLaunchpad]
}

# Assign users to Role Collection: Launchpad_Admin
resource "btp_subaccount_role_collection_assignment" "launchpad_admin" {
  for_each             = toset("${var.admins}")
  subaccount_id        = btp_subaccount.trial.id
  role_collection_name = "Launchpad_Admin"
  user_name            = each.value
  depends_on           = [btp_subaccount_subscription.build_workzone_subscribe]
}

resource "btp_subaccount_subscription" "identity_instance" {
  subaccount_id = btp_subaccount.trial.id
  app_name      = "sap-identity-services-onboarding"
  plan_name     = "default"
  parameters = jsonencode({
    cloud_service = "TEST"
  })
}

resource "btp_subaccount_trust_configuration" "customized" {
  subaccount_id     = btp_subaccount.trial.id
  identity_provider = element(split("/", btp_subaccount_subscription.identity_instance.subscription_url), 2)
}

locals {
  project_subaccount_cf_org = var.subdomain
}

module "hana_cloud_setup" {
  source = "github.com/gregorwolf/btp-terraform-samples.git?ref=1a98f12cc9e1dc9cf379d279c55c7e34a45133f9//released/usecases/genai-setup/modules/hana-cloud"

  subaccount_id        = btp_subaccount.trial.id
  hana_system_password = var.hana_system_password
  hana_appname         = var.hana_appname
  hana_service_name    = var.hana_service_name
  hana_memory          = var.hana_memory
  admins               = var.admins
}

# module "cloudfoundry_environment" {
#   source = "github.com/SAP-samples/btp-terraform-samples.git//released/dsag/betriebstag2024/modules/environment/cloudfoundry/envinstance_cf"

#   subaccount_id           = btp_subaccount.trial.id
#   instance_name           = local.project_subaccount_cf_org
#   cf_org_name             = local.project_subaccount_cf_org
#   plan_name               = "trial"
#   cf_org_managers         = []
#   cf_org_billing_managers = []
#   cf_org_auditors         = []
# }

# module "cloudfoundry_space" {
#   source = "github.com/SAP-samples/btp-terraform-samples.git//released/dsag/betriebstag2024/modules/environment/cloudfoundry/space_cf"

#   cf_org_id           = module.cloudfoundry_environment.cf_org_id
#   name                = var.cf_space_name
#   cf_space_managers   = []
#   cf_space_developers = []
#   cf_space_auditors   = []
# }
