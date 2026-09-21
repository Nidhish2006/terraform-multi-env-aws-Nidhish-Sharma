# Terraform Multi-Environment AWS Infrastructure

## Overview

This project implements multi-environment AWS infrastructure using
Terraform.

The same Terraform configuration is used for both **Dev** and **Prod**
environments. Terraform workspaces provide separate state for each
environment, while separate variable files provide environment-specific
configuration.

## Project Objectives

-   Use Terraform to provision AWS infrastructure.
-   Maintain separate `dev` and `prod` workspaces.
-   Use variables instead of hardcoding environment-specific values.
-   Use Terraform data sources to dynamically retrieve existing AWS
    information.
-   Keep Dev and Prod configurations different.
-   Use tags to identify the environment.
-   Validate and format the Terraform configuration.

## Project Structure

``` text
DevOps_MSE_1/
├── main.tf
├── variables.tf
├── terraform.tf
├── outputs.tf
├── terraform.tfvars.dev
├── terraform.tfvars.prod
├── .terraform.lock.hcl
├── .gitignore
└── README.md
```

### File Description

  -----------------------------------------------------------------------
  File                                Description
  ----------------------------------- -----------------------------------
  `main.tf`                           Contains Terraform data sources,
                                      Security Group, and EC2 resources

  `variables.tf`                      Defines input variables

  `terraform.tf`                      Defines Terraform requirements and
                                      AWS provider configuration

  `outputs.tf`                        Defines EC2 instance IDs and
                                      private IP outputs

  `terraform.tfvars.dev`              Environment-specific values for Dev

  `terraform.tfvars.prod`             Environment-specific values for
                                      Prod

  `.terraform.lock.hcl`               Locks the selected Terraform
                                      provider version information

  `.gitignore`                        Prevents Terraform state and
                                      generated files from being
                                      committed
  -----------------------------------------------------------------------

## Environments

### Dev Environment

  Configuration     Value
  ----------------- ------------
  Workspace         `dev`
  Instance Type     `t3.micro`
  Instance Count    `1`
  Environment Tag   `dev`

### Prod Environment

  Configuration     Value
  ----------------- ------------
  Workspace         `prod`
  Instance Type     `t3.small`
  Instance Count    `3`
  Environment Tag   `prod`

Both environments use the same Terraform configuration but different
variable values.

## Terraform Data Sources

The configuration uses the following AWS data sources:

1.  **Default VPC** - Retrieves the existing default VPC.
2.  **Subnets** - Retrieves subnets belonging to the selected VPC.
3.  **Availability Zones** - Retrieves currently available AWS
    Availability Zones.
4.  **Amazon Linux AMI** - Dynamically finds the latest matching Amazon
    Linux AMI.

These data sources allow the configuration to use existing AWS
information instead of hardcoding resource IDs.

## Resources

The configuration creates:

-   One Security Group per environment.
-   EC2 instances according to the environment configuration.

### Dev

``` text
1 × t3.micro EC2 instance
1 × Security Group
```

### Prod

``` text
3 × t3.small EC2 instances
1 × Security Group
```

The EC2 instances use dynamically retrieved subnet and AMI information.

## Resource Tagging

Resources are tagged with environment information.

Example:

``` hcl
tags = {
  Name        = "${var.project_name}-${var.environment}-${count.index + 1}"
  Environment = var.environment
  Owner       = var.owner
}
```

This allows resources to be identified by their environment.

## Terraform Workspaces

The project uses two Terraform workspaces:

``` text
dev
prod
```

Each workspace maintains its own Terraform state.

Create the workspaces:

``` bash
terraform workspace new dev
terraform workspace new prod
```

List workspaces:

``` bash
terraform workspace list
```

Switch to Dev:

``` bash
terraform workspace select dev
```

Switch to Prod:

``` bash
terraform workspace select prod
```

## Terraform Commands

### Initialize Terraform

``` bash
terraform init
```

Initializes the Terraform working directory and downloads the required
provider.

### Format the Configuration

``` bash
terraform fmt
```

Formats the Terraform configuration files.

### Validate the Configuration

``` bash
terraform validate
```

Checks whether the Terraform configuration is syntactically valid and
internally consistent.

### Plan Dev

``` bash
terraform workspace select dev
terraform plan -var-file="terraform.tfvars.dev"
```

### Apply Dev

``` bash
terraform workspace select dev
terraform apply -var-file="terraform.tfvars.dev"
```

### Plan Prod

``` bash
terraform workspace select prod
terraform plan -var-file="terraform.tfvars.prod"
```

### Apply Prod

``` bash
terraform workspace select prod
terraform apply -var-file="terraform.tfvars.prod"
```

## Destroying Infrastructure

Infrastructure is destroyed separately for each workspace.

### Destroy Dev

``` bash
terraform workspace select dev
terraform destroy -var-file="terraform.tfvars.dev"
```

For automatic approval:

``` bash
terraform destroy -var-file="terraform.tfvars.dev" -auto-approve
```

### Destroy Prod

``` bash
terraform workspace select prod
terraform destroy -var-file="terraform.tfvars.prod"
```

For automatic approval:

``` bash
terraform destroy -var-file="terraform.tfvars.prod" -auto-approve
```

`terraform destroy` operates on the currently selected workspace, so Dev
and Prod should be handled separately.

## Outputs

After applying the configuration, the following outputs can be viewed
using:

``` bash
terraform output
```

Available outputs include:

-   EC2 instance IDs
-   EC2 private IP addresses

## Verification

Useful verification commands:

``` bash
terraform workspace list
terraform validate
terraform fmt
terraform state list
terraform output
```

On PowerShell, the number of data blocks can be checked with:

``` powershell
(Select-String -Path main.tf -Pattern '^data ').Count
```

## Security and State Files

Terraform state files and the `.terraform` directory are intentionally
excluded from Git using `.gitignore`.

The repository does not contain AWS access keys or secret credentials.

## Summary

This project demonstrates a Terraform-based multi-environment setup
using:

-   Terraform workspaces
-   Input variables
-   Environment-specific `.tfvars` files
-   AWS data sources
-   EC2 instances
-   Security Groups
-   Resource tagging
-   Terraform outputs
-   Separate Dev and Prod configurations

The main design principle is to reuse the same Terraform code while
changing environment-specific values through workspaces and variable
files.
