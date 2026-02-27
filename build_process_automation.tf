resource "btp_subaccount_entitlement" "process_automation_service" {
  subaccount_id = btp_subaccount.trial.id
  service_name  = "process-automation-service"
  plan_name     = "standard"
}

data "btp_subaccount_service_plan" "process_automation_service" {
  subaccount_id = btp_subaccount.trial.id
  name          = "standard"
  offering_name = "process-automation-service"
}

resource "btp_subaccount_entitlement" "process_automation" {
  subaccount_id = btp_subaccount.trial.id
  service_name  = "process-automation"
  plan_name     = "free"
}

resource "btp_subaccount_subscription" "process_automation" {
  subaccount_id = btp_subaccount.trial.id
  app_name      = "process-automation"
  plan_name     = "free"
  depends_on    = [btp_subaccount_trust_configuration.customized]
  timeouts = {
    create = "30m"
  }
  # btp_subaccount_entitlement.integration_suite, 
}

resource "btp_subaccount_role_collection_assignment" "process_automation_admin" {
  for_each             = toset("${var.admins}")
  subaccount_id        = btp_subaccount.trial.id
  role_collection_name = "ProcessAutomationAdmin"
  user_name            = each.value
  depends_on           = [btp_subaccount_subscription.process_automation]
}

resource "btp_subaccount_role_collection_assignment" "process_automation_developer" {
  for_each             = toset("${var.admins}")
  subaccount_id        = btp_subaccount.trial.id
  role_collection_name = "ProcessAutomationDeveloper"
  user_name            = each.value
  depends_on           = [btp_subaccount_subscription.process_automation]
}

resource "btp_subaccount_role_collection_assignment" "process_automation_participant" {
  for_each             = toset("${var.admins}")
  subaccount_id        = btp_subaccount.trial.id
  role_collection_name = "ProcessAutomationParticipant"
  user_name            = each.value
  depends_on           = [btp_subaccount_subscription.process_automation]
}

resource "btp_subaccount_service_instance" "process_automation_service_instance" {
  subaccount_id = btp_subaccount.trial.id
  # The service plan ID can be looked up via the data source btp_subaccount_service_plan
  serviceplan_id = data.btp_subaccount_service_plan.process_automation_service.id
  name           = "process-automation"
  depends_on     = [btp_subaccount_entitlement.process_automation_service]
}
resource "btp_subaccount_service_binding" "sap_process_automation_service" {
  subaccount_id       = btp_subaccount.trial.id
  service_instance_id = btp_subaccount_service_instance.process_automation_service_instance.id
  name                = "sap_process_automation_service"
  depends_on          = [btp_subaccount_service_instance.process_automation_service_instance]
}
resource "btp_subaccount_service_binding" "sap_process_automation_service_user_access" {
  subaccount_id       = btp_subaccount.trial.id
  service_instance_id = btp_subaccount_service_instance.process_automation_service_instance.id
  name                = "sap_process_automation_service_user_access"
  depends_on          = [btp_subaccount_service_instance.process_automation_service_instance]
}
