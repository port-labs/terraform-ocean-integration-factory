locals {
  name_suffix = "port-ocean-aws-exporter" # TODO: Change this to a unique name
}


resource "aws_cloudwatch_event_bus" "eventbus" {
  name = "port-ocean-aws-exporter-eventbus-${local.name_suffix}"
}

resource "aws_iam_role" "api_destinations_role" {
  name = "api-destinations-role-${local.name_suffix}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "events.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  inline_policy {
    name = "eventbridge-api-destinations"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [{
        Effect   = "Allow"
        Action   = "events:InvokeApiDestination"
        Resource = aws_cloudwatch_event_api_destination.api_destination.arn
      }]
    })
  }
}

resource "aws_cloudwatch_event_connection" "connection" {
  name               = "api-destinations-connection-${local.name_suffix}"
  authorization_type = "API_KEY"
  description        = "Connection to Port AWS Ocean"

  auth_parameters {
    api_key {
      key   = "x-port-aws-ocean-api-key"
      value = var.api_key_param
    }
  }
}

resource "aws_cloudwatch_event_api_destination" "api_destination" {
  name                = "api-destination-${local.name_suffix}"
  http_method         = "POST"
  invocation_endpoint = var.webhook_url
  connection_arn      = aws_cloudwatch_event_connection.connection.arn
}