# Terraform Module: AWS Integration Setup

## Overview

This Terraform module sets up the necessary AWS infrastructure for integrating with Port using ECS and Fargate. The module provisions an ECS cluster, ECS task definition, and other related resources.

## Prerequisites

- Ensure you have Terraform installed on your machine. You can download it from the [official Terraform website](https://www.terraform.io/downloads.html).
- AWS CLI configured with appropriate credentials.
- Ensure your AWS user has the necessary permissions to create and manage ECS, IAM, and VPC resources.

## Installation

1. **Clone the repository** containing the Terraform module.
2. **Navigate to the directory** where the module is located.

## Usage

Create a `main.tf` file in your Terraform project and include the following code, modifying the values as necessary:

```hcl
module "aws_integration" {
  source = "./path-to-your-module"

  subnets             = ["subnet-1", "subnet-2", "subnet-3"]
  port = {
    client_id     = "<client-id>"
    client_secret = "<client-secret>"
  }
  integration = {
    identifier = "my-aws-integration"
    config = {
      live_events_api_key = "<your-api-key>"
      organization_role_arn  = "arn:.../organization-role"
      account_read_role_name = "ocean-integration-role"
    }
  }
  cluster_name              = "port-ocean-aws-exporter"
  vpc_id                    = "vpc-1"
  initialize_port_resources = true
  create_default_sg         = false
  allow_incoming_requests   = true
}
```

### Variables Explanation

- `subnets`: List of subnet IDs where the ECS tasks will run.
- `port.client_id`: The client ID for the Port integration.
- `port.client_secret`: The client secret for the Port integration.
- `integration.identifier`: The identifier for the integration.
- `integration.config.live_events_api_key`: API key used to authenticate with the live events API.
- `integration.config.organization_role_arn` (optional): ARN of the role used to assume the organization role.
- `integration.config.account_read_role_name` (optional): Name of the role used to assume the read role in the account.
- `cluster_name` (optional): Name of the ECS cluster.
- `vpc_id` (optional): VPC ID where the cluster will be created.
- `initialize_port_resources`: Boolean to initialize Port resources.
- `create_default_sg`: Boolean to create a default security group.
- `allow_incoming_requests`: Boolean to allow incoming requests to the ECS tasks.

### Steps to Deploy

1. **Initialize the Terraform configuration** by running:

   ```sh
   terraform init
   ```

2. **Review the Terraform plan** to see the changes that will be made:

   ```sh
   terraform plan
   ```

3. **Apply the Terraform plan** to create the resources:
   ```sh
   terraform apply
   ```

## Notes

- Ensure that the specified subnets and VPC exist in your AWS account.
- The AWS credentials provided (if provided) must have the necessary permissions to create and manage the specified resources.
