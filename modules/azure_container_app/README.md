# Ocean Integration Azure ContainerApp Terraform module

Terraform module which creates Ocean Integration on Azure ContainerApp.


## Usage


### Example of generic ocean integration over Azure containerApp:
```hcl
module "ocean-containerapp_example_basic-integration" {
  source  = "port-labs/ocean-containerapp/azure//examples/base"
  version = "=>0.0.4"
  
  port_client_id = "xxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  port_client_secret = "xxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  integration_type = "some-integration"
}
```

### Example for Azure Integration:
```hcl
module "ocean-containerapp_example_azure-integration" {
  source  = "port-labs/ocean-containerapp/azure//examples/azure-integration"
  version = "=>0.0.4"
  
  port_client_id = "xxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  port_client_secret = "xxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  subscription_id = "xxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}
```

