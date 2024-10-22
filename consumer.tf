resource "btp_subaccount" "consumer-01" {
  name      = "consumer-01"
  subdomain = "${var.subdomain}-consumer-01"
  region    = var.region
}

resource "btp_subaccount_entitlement" "consumer-01-SAPLaunchpad" {
  subaccount_id = btp_subaccount.consumer-01.id
  service_name  = "SAPLaunchpad"
  plan_name     = "standard"
}

resource "btp_subaccount_subscription" "consumer-01-build_workzone_subscribe" {
  subaccount_id = btp_subaccount.consumer-01.id
  app_name      = "SAPLaunchpad"
  plan_name     = "standard"
  depends_on    = [btp_subaccount_entitlement.consumer-01-SAPLaunchpad]
}
# Assign users to Role Collection: Launchpad_Admin
resource "btp_subaccount_role_collection_assignment" "consumer-01-launchpad_admin" {
  for_each             = toset("${var.admins}")
  subaccount_id        = btp_subaccount.consumer-01.id
  role_collection_name = "Launchpad_Admin"
  user_name            = each.value
  depends_on           = [btp_subaccount_subscription.consumer-01-build_workzone_subscribe]
}

resource "btp_subaccount_trust_configuration" "consumer-01-customized" {
  subaccount_id     = btp_subaccount.consumer-01.id
  identity_provider = element(split("/", btp_subaccount_subscription.identity_instance.subscription_url), 2)
}
