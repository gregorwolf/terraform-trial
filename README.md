# Terraform Setup for BTP Trial

Right now this terraform setup creates:

- Import the subaccount named 'trial'
- Add entitlements for
  - Alert Notification
  - SAP Build Work Zone, standard edition
  - SAP Cloud Identity Services
  - HANA Cloud tools
  - HANA Cloud
- Create an instance of
  - SAP Build Work Zone, standard edition
  - SAP Cloud Identity Services
  - HANA Cloud tools
  - HANA Cloud
- Add trust to the SAP Cloud Identity Services instance

## References

- [Terraform Provider for SAP BTP](https://registry.terraform.io/providers/SAP/btp/latest/docs)
- [btp-terraform-samples](https://github.com/SAP-samples/btp-terraform-samples/)

## Prerequisites

BTP Trial account in the region `us10`.

Create .env file in the root directory with the following content:

```bash
TF_VAR_subaccount_id='<Your-trial-Subaccount-ID>'
TF_VAR_subdomain='<Your-Subdomain>'
BTP_ENABLE_SSO='true'
```

then run

```bash
export $(xargs <.env)
```

to load the environment variables. Then follow the [ Get Started with the Terraform Provider for SAP BTP tutorial](https://developers.sap.com/tutorials/btp-terraform-get-started.html)
