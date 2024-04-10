# Terraform-ocean-integration-factory

This repository contains Terraform modules for deploying Ocean integrations on different cloud providers.


## Supported Deployment Methods:

- Azure ContainerApp
- AWS ECS (Coming soon)

## Usage

Don't run Terraform directly from this repository. Instead, use the examples from this repository to deploy your desired integration.

e.g. for Azure ContainerApp:

```hcl
module "my_azure_container_app_example_generic_integration" {
  source  = "port-labs/integration-factory/ocean//examples/azure_container_app_azure_integration"
  version = ">=0.0.17"
  
  integration_type = "some-integration"
  
  port_client_id = "xxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  port_client_secret = "xxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}
```