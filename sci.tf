data "sci_users" "all" {
}

resource "sci_group" "Launchpad_Admin" {
  display_name = "Launchpad_Admin"
  group_members = [
    {
      value = var.ias_user_id
      type  = "User" # Refer to the documentation for valid values
    }
  ]
  depends_on = [btp_subaccount_subscription.identity_instance]
}

resource "btp_subaccount_role_collection_assignment" "Launchpad_Admin" {
  subaccount_id        = btp_subaccount.trial.id
  role_collection_name = "Launchpad_Admin"
  group_name           = sci_group.Launchpad_Admin.id
  origin               = "sap.custom"
  depends_on           = [sci_group.Launchpad_Admin, btp_subaccount_subscription.build_workzone_subscribe]
}

resource "sci_group" "ProcessAutomationAdmin" {
  display_name = "ProcessAutomationAdmin"
  group_members = [
    {
      value = var.ias_user_id
      type  = "User" # Refer to the documentation for valid values
    }
  ]
  depends_on = [btp_subaccount_subscription.identity_instance]
}

resource "btp_subaccount_role_collection_assignment" "ProcessAutomationAdmin" {
  subaccount_id        = btp_subaccount.trial.id
  role_collection_name = "ProcessAutomationAdmin"
  group_name           = sci_group.ProcessAutomationAdmin.id
  origin               = "sap.custom"
  depends_on           = [sci_group.ProcessAutomationAdmin, btp_subaccount_subscription.process_automation]
}

resource "sci_group" "ProcessAutomationDeveloper" {
  display_name = "ProcessAutomationDeveloper"
  group_members = [
    {
      value = var.ias_user_id
      type  = "User" # Refer to the documentation for valid values
    }
  ]
  depends_on = [btp_subaccount_subscription.identity_instance]
}

resource "btp_subaccount_role_collection_assignment" "ProcessAutomationDeveloper" {
  subaccount_id        = btp_subaccount.trial.id
  role_collection_name = "ProcessAutomationDeveloper"
  group_name           = sci_group.ProcessAutomationDeveloper.id
  origin               = "sap.custom"
  depends_on           = [sci_group.ProcessAutomationDeveloper, btp_subaccount_subscription.process_automation]
}

resource "sci_group" "BAS_Developer" {
  display_name = "BAS_Developer"
  group_members = [
    {
      value = var.ias_user_id
      type  = "User" # Refer to the documentation for valid values
    }
  ]
  depends_on = [btp_subaccount_subscription.identity_instance]
}

resource "btp_subaccount_role_collection_assignment" "Business_Application_Studio_Developer" {
  subaccount_id        = btp_subaccount.trial.id
  role_collection_name = "Business_Application_Studio_Developer"
  group_name           = sci_group.BAS_Developer.id
  origin               = "sap.custom"
  depends_on           = [sci_group.BAS_Developer]
}
