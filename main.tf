resource "btp_subaccount" "gw_wz_qa" {
  name      = "Workzone QA"
  subdomain = "gw-wz-qa"
  region    = "us10"
}

resource "btp_subaccount_entitlement" "alert_notification_service" {
  subaccount_id = btp_subaccount.gw_wz_qa.id
  service_name  = "alert-notification"
  plan_name     = "standard"
}

resource "btp_subaccount_entitlement" "SAPLaunchpad" {
  subaccount_id = btp_subaccount.gw_wz_qa.id
  service_name  = "SAPLaunchpad"
  plan_name     = "standard"
}

resource "btp_subaccount_subscription" "build_workzone_subscribe" {
  subaccount_id = btp_subaccount.gw_wz_qa.id
  app_name      = "SAPLaunchpad"
  plan_name     = "standard"
  depends_on    = [btp_subaccount_entitlement.SAPLaunchpad]
}
