# Ocean Integration Azure ContainerApp Terraform module

Terraform module which creates Ocean Integration on Azure ContainerApp.


## Usage


### Example of generic ocean integration over Azure containerApp:
```hcl
module "ocean-containerapp_example_basic-integration" {
  source  = "port-labs/integration-factory/ocean//examples/azure_container_app_generic"
  version = ">=0.0.19"
  
  integration_type = "some-integration"
  
  port_client_id = "xxxxx-xxxx-xxxx-xxxx"
  port_client_secret = "yyyy-yyyy-yyyy-yyyy"
}
```

### Example for Azure Integration:
```hcl
module "ocean-container_app_example_azure-integration" {
  source  = "port-labs/integration-factory/ocean//examples/azure_container_app_azure_integration"
  version = ">=0.0.19"
  
  port_client_id = "xxxxx-xxxx-xxxx-xxxx"
  port_client_secret = "yyyy-yyyy-yyyy-yyyy"
  hosting_subscription_id = "zzzz-zzzz-zzzz-zzzz"
}
```

