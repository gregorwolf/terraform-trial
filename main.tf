resource "btp_subaccount" "wz_qa" {
  name      = "Workzone QA (${var.subdomain})"
  subdomain = "${var.subdomain}-wz-qa"
  region    = "us10"
}

resource "btp_subaccount_entitlement" "alert_notification_service" {
  subaccount_id = btp_subaccount.wz_qa.id
  service_name  = "alert-notification"
  plan_name     = "standard"
}


resource "btp_subaccount_entitlement" "identity_service" {
  subaccount_id = btp_subaccount.wz_qa.id
  service_name  = "sap-identity-services-onboarding"
  plan_name     = "default"
}

resource "btp_subaccount_entitlement" "SAPLaunchpad" {
  subaccount_id = btp_subaccount.wz_qa.id
  service_name  = "SAPLaunchpad"
  plan_name     = "standard"
}

resource "btp_subaccount_subscription" "build_workzone_subscribe" {
  subaccount_id = btp_subaccount.wz_qa.id
  app_name      = "SAPLaunchpad"
  plan_name     = "standard"
  depends_on    = [btp_subaccount_entitlement.SAPLaunchpad]
}

resource "btp_subaccount_subscription" "identity_instance" {
  subaccount_id = btp_subaccount.wz_qa.id
  app_name      = "sap-identity-services-onboarding"
  plan_name     = "default"
  parameters = jsonencode({
    cloud_service = "TEST"
  })
}

resource "btp_subaccount_trust_configuration" "customized" {
  subaccount_id     = btp_subaccount.wz_qa.id
  identity_provider = element(split("/", btp_subaccount_subscription.identity_instance.subscription_url), 2)
}
