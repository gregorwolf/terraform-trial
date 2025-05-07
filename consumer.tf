resource "btp_subaccount" "sub01" {
  name      = "sub01"
  subdomain = "${var.subdomain}-sub01"
  region    = var.region
}

resource "btp_subaccount_entitlement" "sub01-SAPLaunchpad" {
  subaccount_id = btp_subaccount.sub01.id
  service_name  = "SAPLaunchpad"
  plan_name     = "standard"
}

resource "btp_subaccount_subscription" "sub01-build_workzone_subscribe" {
  subaccount_id = btp_subaccount.sub01.id
  app_name      = "SAPLaunchpadSMS"
  plan_name     = "standard"
  depends_on    = [btp_subaccount_entitlement.sub01-SAPLaunchpad, btp_subaccount_trust_configuration.sub01-customized]
}
# Assign users to Role Collection: Launchpad_Admin
resource "btp_subaccount_role_collection_assignment" "sub01-launchpad_admin" {
  for_each             = toset("${var.admins}")
  subaccount_id        = btp_subaccount.sub01.id
  role_collection_name = "Launchpad_Admin"
  user_name            = each.value
  depends_on           = [btp_subaccount_subscription.sub01-build_workzone_subscribe]
}

resource "btp_subaccount_trust_configuration" "sub01-customized" {
  subaccount_id     = btp_subaccount.sub01.id
  identity_provider = element(split("/", btp_subaccount_subscription.identity_instance.subscription_url), 2)
}
