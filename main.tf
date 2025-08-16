resource "btp_subaccount" "trial" {
  name      = "trial"
  subdomain = var.subdomain
  region    = var.region
}
# Uncomment for the import
import {
  id = "daa08ebd-f64e-4901-bb67-6f41a9c01cdb"
  to = btp_subaccount.trial
}

resource "btp_subaccount_entitlement" "alert_notification_service" {
  subaccount_id = btp_subaccount.trial.id
  service_name  = "alert-notification"
  plan_name     = "standard"
}

resource "btp_subaccount_entitlement" "auditlog_viewer_service" {
  subaccount_id = btp_subaccount.trial.id
  service_name  = "auditlog-viewer"
  plan_name     = "free"
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
  app_name      = "SAPLaunchpadSMS"
  plan_name     = "standard"
  depends_on    = [btp_subaccount_entitlement.SAPLaunchpad, btp_subaccount_trust_configuration.customized]
}

# Assign users to Role Collection: Launchpad_Admin
resource "btp_subaccount_role_collection_assignment" "launchpad_admin" {
  for_each             = toset("${var.admins}")
  subaccount_id        = btp_subaccount.trial.id
  role_collection_name = "Launchpad_Admin"
  user_name            = each.value
  depends_on           = [btp_subaccount_subscription.build_workzone_subscribe]
}

# Assign users to Role Collection: Business_Application_Studio_Developer
resource "btp_subaccount_role_collection_assignment" "business_application_studio_developer" {
  for_each             = toset("${var.admins}")
  subaccount_id        = btp_subaccount.trial.id
  role_collection_name = "Business_Application_Studio_Developer"
  user_name            = each.value
}

resource "btp_subaccount_subscription" "identity_instance" {
  subaccount_id = btp_subaccount.trial.id
  app_name      = "sap-identity-services-onboarding"
  plan_name     = "default"
  parameters = jsonencode({
    cloud_service = "TEST"
  })
  depends_on = [btp_subaccount_entitlement.identity_service]
}

resource "btp_subaccount_trust_configuration" "customized" {
  subaccount_id     = btp_subaccount.trial.id
  identity_provider = element(split("/", btp_subaccount_subscription.identity_instance.subscription_url), 2)
}

locals {
  project_subaccount_cf_org = var.subdomain
}

resource "btp_subaccount_subscription" "auditlog_viewer" {
  subaccount_id = btp_subaccount.trial.id
  app_name      = "auditlog-viewer"
  plan_name     = "free"
  depends_on    = [btp_subaccount_entitlement.auditlog_viewer_service]
}

resource "btp_subaccount_role_collection" "auditlog_auditor_role_collection" {
  subaccount_id = btp_subaccount.trial.id
  name          = "Auditlog_Auditor"
  description   = "Auditlog Auditor Role Collection"

  roles = [
    {
      name                 = "Auditlog_Auditor"
      role_template_app_id = "auditlog-viewer!t1187"
      role_template_name   = "Auditlog_Auditor"
    },
    {
      name                 = "Auditlog_Auditor"
      role_template_app_id = "auditlog-management!b1187"
      role_template_name   = "Auditlog_Auditor"
    }
  ]
  depends_on = [btp_subaccount_subscription.auditlog_viewer]
}

resource "btp_subaccount_role_collection_assignment" "auditlog_auditor" {
  for_each             = toset("${var.admins}")
  subaccount_id        = btp_subaccount.trial.id
  role_collection_name = "Auditlog_Auditor"
  user_name            = each.value
  depends_on           = [btp_subaccount_role_collection.auditlog_auditor_role_collection]
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
