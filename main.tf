resource "btp_subaccount" "trial" {
  name      = "trial"
  subdomain = var.subdomain
  region    = var.region
}
## Uncomment for the import
# import {
#   id = "<replace with the subaccount id>"
#   to = btp_subaccount.trial
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
}

resource "btp_subaccount_trust_configuration" "customized" {
  subaccount_id     = btp_subaccount.trial.id
  identity_provider = element(split("/", btp_subaccount_subscription.identity_instance.subscription_url), 2)
}

locals {
  project_subaccount_cf_org = var.subdomain
}

# module "hana_cloud_setup" {
#   source = "./modules/hana-cloud"

#   subaccount_id        = btp_subaccount.trial.id
#   hana_system_password = var.hana_system_password
#   hana_appname         = var.hana_appname
#   hana_service_name    = var.hana_service_name
#   hana_memory          = var.hana_memory
#   admins               = var.admins
# }

module "hana_cloud_setup" {
  source = "github.com/codeyogi911/terraform-sap-hana-cloud"

  subaccount_id              = btp_subaccount.trial.id
  service_name               = "hana-cloud-trial"
  plan_name                  = "hana"
  hana_cloud_tools_app_name  = "hana-cloud-tools-trial"
  hana_cloud_tools_plan_name = "tools"
  admins                     = var.admins
  viewers                    = var.admins
  security_admins            = var.admins
  instance_name              = var.hana_service_name
  memory                     = 16
  vcpu                       = 1
  whitelist_ips              = ["0.0.0.0/0"]
  database_mappings = [
    # provide mappings for cf or kyma env
    {
      organization_guid = var.cf_organization_guid # your cf org id
      space_guid        = var.cf_space_guid        # your space guid
    }
  ]
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
