### Example of generic ocean integration over Azure containerApp:

```hcl
module "my_azure_containerapp_example_generic_integration" {
  source  = "port-labs/integration-factory/ocean//examples/azure_container_app_azure_integration"
  version = "=>0.0.4"
  
  integration_type = "some-integration"
  
  port_client_id = "xxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  port_client_secret = "xxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  hosting_subscription_id = "xxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}
```

### Example for generic ocean integration over Azure ContainerApp with secrets:

```hcl
module "my_azure_containerapp_example_generic_integration_with_secrets" { 
  source  = "port-labs/integration-factory/ocean//examples/azure_container_app_generic"
  version = "=>0.0.4"
  
  integration_type = "some-integration"
  
  port_client_id = "xxxxx-xxxx-xxxx-xxxx"
  port_client_secret = "yyyy-yyyy-yyyy-yyyy"
  hosting_subscription_id = "zzzz-zzzz-zzzz-zzzz"  
  
  additional_secrets = {
    OCEAN__INTEGRATION__CONFIG__MY_INTEGRATION_SECRET = "value"
    MY_THIRD_PARTY_SECRET = "some-value"
  }
}
```

### Example for generic ocean integration over Azure ContainerApp with environments variables:

```hcl
module "my_azure_containerapp_example_generic_integration_with_secrets" { 
  source  = "port-labs/integration-factory/ocean//examples/azure_container_app_generic"
  version = "=>0.0.4"
  
  integration_type = "some-integration"
  
  port_client_id = "xxxxx-xxxx-xxxx-xxxx"
  port_client_secret = "yyyy-yyyy-yyyy-yyyy"
  hosting_subscription_id = "zzzz-zzzz-zzzz-zzzz"
  
  additional_environments_variables = {
    OCEAN__INTEGRATION__CONFIG__MY_INTEGRATION_ENV = "value"
    MY_THIRD_PARTY_API_URL = "some-value"
  }
}
```