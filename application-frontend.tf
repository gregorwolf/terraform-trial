resource "btp_subaccount_entitlement" "application_frontend" {
  subaccount_id = btp_subaccount.trial.id
  service_name  = "application-frontend"
  plan_name     = "trial"
}

resource "btp_subaccount_subscription" "application_frontend" {
  subaccount_id = btp_subaccount.trial.id
  app_name      = "application-frontend"
  plan_name     = "trial"
  depends_on    = [btp_subaccount_trust_configuration.customized]
}

resource "btp_subaccount_role_collection" "application_frontend_developer" {
  subaccount_id = btp_subaccount.trial.id
  name          = "Application_Frontend_Developer"
  description   = "Application Frontend Developer Role Collection"

  roles = [
    {
      name                 = "Application_Frontend_Developer"
      role_template_app_id = "us10-appfront!b415322"
      role_template_name   = "Application_Frontend_Developer"
    }
  ]
  depends_on = [btp_subaccount_subscription.application_frontend]
}

resource "btp_subaccount_role_collection_assignment" "application_frontend_developer" {
  for_each             = toset("${var.admins}")
  subaccount_id        = btp_subaccount.trial.id
  role_collection_name = "Application_Frontend_Developer"
  user_name            = each.value
  depends_on           = [btp_subaccount_role_collection.application_frontend_developer]
}
