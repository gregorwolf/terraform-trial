resource "btp_subaccount_entitlement" "hana_cloud_tools" {
  subaccount_id = btp_subaccount.trial.id
  service_name  = "hana-cloud-tools-trial"
  plan_name     = "tools"
}

resource "btp_subaccount_subscription" "hana_cloud_tools" {
  subaccount_id = btp_subaccount.trial.id
  app_name      = "hana-cloud-tools-trial"
  plan_name     = "tools"
  depends_on    = [btp_subaccount_entitlement.hana_cloud_tools]
}

resource "btp_subaccount_role_collection_assignment" "hana_cloud_admin_group" {
  subaccount_id        = btp_subaccount.trial.id
  role_collection_name = "SAP HANA Cloud Administrator"
  group_name           = "HANACloudAdministrator"
  origin               = "sap.custom"
  depends_on           = [btp_subaccount_subscription.hana_cloud_tools, btp_subaccount_trust_configuration.customized]
}

resource "btp_subaccount_role_collection_assignment" "hana_cloud_security_admin_group" {
  subaccount_id        = btp_subaccount.trial.id
  role_collection_name = "SAP HANA Cloud Security Administrator"
  group_name           = "HANACloudSecurityAdministrator"
  origin               = "sap.custom"
  depends_on           = [btp_subaccount_subscription.hana_cloud_tools, btp_subaccount_trust_configuration.customized]
}

resource "btp_subaccount_entitlement" "hana_cloud" {
  subaccount_id = btp_subaccount.trial.id
  service_name  = "hana-cloud-trial"
  plan_name     = "hana"
}
