# Terraform Setup for BTP Trial

Right now this terraform setup creates:

- A new subaccount named 'Workzone QA'
- Entitlements for
  - Alert Notification
  - SAP Build Work Zone, standard edition
- An instance of SAP Build Work Zone, standard edition

## Prerequisites

Create .env file in the root directory with the following content:

```bash
TF_VAR_globalaccount='<Your-Global-Account-Name>'
BTP_ENABLE_SSO='true'
```

then run

```bash
export $(xargs <.env)
```

to load the environment variables. Then follow the [ Get Started with the Terraform Provider for SAP BTP tutorial](https://developers.sap.com/tutorials/btp-terraform-get-started.html)
