variable "hana_system_password" {
  description = "SAP HANA system password"
  type        = string
}

data "cloudfoundry_service_plan" "hana_cloud" {
  name                  = "hana-free"
  service_offering_name = "hana-cloud"
}

resource "cloudfoundry_service_instance" "hana_cloud" {
  name         = "hana-cloud"
  type         = "managed"
  tags         = ["hana", "hana-trial"]
  space        = var.cf_space_guid
  service_plan = data.cloudfoundry_service_plan.hana_cloud.id
  timeouts = {
    create = "30m"
  }
  parameters = <<EOT
{
    "data": {
        "memory": 16,
        "systempassword": "${var.hana_system_password}",
        "edition": "cloud",
        "whitelistIPs" : ["0.0.0.0/0"],
        "databaseMappings": [
            {
                "organization_guid": "${var.cf_organization_guid}",
                "space_guid": "${var.cf_space_guid}"
            }
        ]
    }
}
EOT
}
