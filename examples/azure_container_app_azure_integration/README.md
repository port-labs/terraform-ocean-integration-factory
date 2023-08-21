### Example for Azure Integration over Azure ContainerApp:

```hcl
module "ocean-containerapp_example_azure-integration" {
  source  = "port-labs/integration-factory/ocean//examples/azure_container_app_azure_integration"
  version = "=>0.0.4"
  
  port_client_id = "xxxxx-xxxx-xxxx-xxxx"
  port_client_secret = "yyyy-yyyy-yyyy-yyyy"
  
  additional_secrets = {
    OCEAN__INTEGRATION__CONFIG__SUBSCRIPTION_ID = "zzzz-zzzz-zzzz-zzzz"
  }
}
```

### Example for Azure Integration over Azure ContainerApp with specified subscription id to be used for hosting:

```hcl
module "ocean-containerapp_example_azure-integration" {
  source  = "port-labs/integration-factory/ocean//examples/azure_container_app_azure_integration"
  version = "=>0.0.4"
  
  port_client_id = "xxxxx-xxxx-xxxx-xxxx"
  port_client_secret = "yyyy-yyyy-yyyy-yyyy"
  hosting_subscription_id = "zzzz-zzzz-zzzz-zzzz"  
  
  additional_secrets = {
    OCEAN__INTEGRATION__CONFIG__SUBSCRIPTION_ID = "zzzz-zzzz-zzzz-zzzz"
  }
}
```

### Example for Azure Integration over Azure ContainerApp with Existing Event Grid System Topic:

```hcl
module "ocean-containerapp_example_azure-integration" {
  source  = "port-labs/integration-factory/ocean//examples/azure_container_app_azure_integration"
  version = "=>0.0.4"
  
  port_client_id = "xxxxx-xxxx-xxxx-xxxx"
  port_client_secret = "yyyy-yyyy-yyyy-yyyy"
  hosting_subscription_id = "zzzz-zzzz-zzzz-zzzz"  
  
  additional_secrets = {
    OCEAN__INTEGRATION__CONFIG__SUBSCRIPTION_ID = "zzzz-zzzz-zzzz-zzzz"
  }
  
  event_grid_system_topic_name = "my-event-grid-system-topic-name"
}
```
