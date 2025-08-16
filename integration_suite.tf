resource "btp_subaccount_subscription" "integration_suite" {
  subaccount_id = btp_subaccount.trial.id
  app_name      = "it-cpitrial05-prov"
  plan_name     = "trial"
  depends_on    = [btp_subaccount_trust_configuration.customized]
  # btp_subaccount_entitlement.integration_suite, 
}

resource "btp_subaccount_role_collection_assignment" "integration_provisioner_user" {
  for_each             = toset("${var.admins}")
  subaccount_id        = btp_subaccount.trial.id
  role_collection_name = "Integration_Provisioner"
  user_name            = each.value
  depends_on           = [btp_subaccount_subscription.integration_suite]
}

resource "btp_subaccount_role_collection_assignment" "integration_provisioner_group" {
  subaccount_id        = btp_subaccount.trial.id
  role_collection_name = "Integration_Provisioner"
  group_name           = "IntegrationProvisioner"
  origin               = "sap.custom"
  depends_on           = [btp_subaccount_subscription.integration_suite, btp_subaccount_trust_configuration.customized]
}
