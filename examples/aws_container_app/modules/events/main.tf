# S3
resource "aws_cloudwatch_event_rule" "s3_event_bridge_rule" {
  name           = "port-aws-ocean-sync-s3-trails"
  description    = "Capture S3 events"
  event_bus_name = var.event_bus_name
  event_pattern = jsonencode({
    source      = ["aws.s3"]
    detail-type = ["AWS API Call via CloudTrail"]
    detail = {
      eventSource = ["s3.amazonaws.com"]
      eventName   = ["CreateBucket", "PutBucket", "DeleteBucket"]
    }
  })
}

resource "aws_cloudwatch_event_target" "s3_event_bridge_target" {
  rule           = aws_cloudwatch_event_rule.s3_event_bridge_rule.name
  target_id      = var.api_destination_name
  arn            = var.api_destination_arn
  role_arn       = var.api_destinations_role_arn
  event_bus_name = var.event_bus_name
  input_transformer {
    input_paths = {
      accountId         = "$.detail.userIdentity.accountId"
      awsRegion         = "$.detail.awsRegion"
      eventName         = "$.detail.eventName"
      requestBucketName = "$.detail.requestParameters.bucketName"
    }
    input_template = jsonencode({
      resource_type = "AWS::S3::Bucket"
      accountId     = "<accountId>"
      awsRegion     = "<awsRegion>"
      eventName     = "<eventName>"
      identifier    = "<requestBucketName>"
    })
  }
}

# CloudFormation
resource "aws_cloudwatch_event_rule" "cloudformation_cloud_trail_event_bridge_rule" {
  name           = "port-aws-ocean-sync-cloudformation-trails"
  description    = "Capture CloudFormation events"
  event_bus_name = var.event_bus_name
  event_pattern = jsonencode({
    source      = ["aws.cloudformation"]
    detail-type = ["AWS API Call via CloudTrail"]
    detail = {
      eventSource = ["cloudformation.amazonaws.com"]
      eventName   = ["CreateStack", "UpdateStack", "DeleteStack"]
    }
  })
}

resource "aws_cloudwatch_event_target" "CloudformationCloudTrailEventBridgeTarget" {
  rule           = aws_cloudwatch_event_rule.cloudformation_cloud_trail_event_bridge_rule.name
  target_id      = var.api_destination_name
  arn            = var.api_destination_arn
  role_arn       = var.api_destinations_role_arn
  event_bus_name = var.event_bus_name
  input_transformer {
    input_paths = {
      accountId = "$.detail.userIdentity.accountId"
      eventName = "$.detail.eventName"
      awsRegion = "$.detail.awsRegion"
      stackName = "$.detail.requestParameters.stackName"
    }
    input_template = jsonencode({
      resource_type = "AWS::CloudFormation::Stack"
      accountId     = "<accountId>"
      awsRegion     = "<awsRegion>"
      eventName     = "<eventName>"
      identifier    = "<stackName>"
    })
  }
}

resource "aws_cloudwatch_event_rule" "cloudformation_status_event_bridge_rule" {
  name           = "port-aws-ocean-sync-cloudformation-status-change-trails"
  description    = "Capture CloudFormation status change events"
  event_bus_name = var.event_bus_name
  event_pattern = jsonencode({
    source      = ["aws.cloudformation"]
    detail-type = ["CloudFormation Stack Status Change"]
  })
}

resource "aws_cloudwatch_event_target" "cloudformation_status_event_bridge_target" {
  rule           = aws_cloudwatch_event_rule.cloudformation_status_event_bridge_rule.name
  target_id      = var.api_destination_name
  arn            = var.api_destination_arn
  role_arn       = var.api_destinations_role_arn
  event_bus_name = var.event_bus_name
  input_transformer {
    input_paths = {
      accountId = "$.detail.userIdentity.accountId"
      region    = "$.region"
      stackId   = "$.detail.stack-id"
      status    = "$.detail.status-details.status"
    }
    input_template = jsonencode({
      resource_type = "AWS::CloudFormation::Stack"
      accountId     = "<accountId>"
      awsRegion     = "<region>"
      identifier    = "<stackId>"
      eventName     = "if <status> == 'DELETE_COMPLETE' then 'delete' else 'upsert' end"
    })
  }
}

# EC2
resource "aws_cloudwatch_event_rule" "ec2_instance_tags_event_rule" {
  name           = "port-aws-ocean-sync-ec2-tags-trails"
  description    = "Capture EC2 instance tag events"
  event_bus_name = var.event_bus_name
  event_pattern = jsonencode({
    source      = ["aws.ec2"]
    detail-type = ["AWS API Call via CloudTrail"]
    detail = {
      eventSource = ["ec2.amazonaws.com"]
      eventName   = ["DeleteTags", "CreateTags"]
    }
  })
}

resource "aws_cloudwatch_event_target" "ec2_instance_tags_event_target" {
  rule           = aws_cloudwatch_event_rule.ec2_instance_tags_event_rule.name
  target_id      = var.api_destination_name
  arn            = var.api_destination_arn
  role_arn       = var.api_destinations_role_arn
  event_bus_name = var.event_bus_name
  input_transformer {
    input_paths = {
      accountId  = "$.detail.userIdentity.accountId"
      eventName  = "$.detail.eventName"
      awsRegion  = "$.detail.awsRegion"
      instanceId = "$.detail.requestParameters.resourcesSet.items[0].resourceId"
    }
    input_template = jsonencode({
      resource_type = "AWS::EC2::Instance"
      accountId     = "<accountId>"
      awsRegion     = "<awsRegion>"
      identifier    = "<instanceId>"
      eventName     = "<eventName>"
    })
  }
}

resource "aws_cloudwatch_event_rule" "ec2_instance_status_change_event_rule" {
  name           = "port-aws-exporter-sync-ec2-instance-status-change-trails"
  description    = "Capture EC2 instance status change events"
  event_bus_name = var.event_bus_name
  event_pattern = jsonencode({
    source      = ["aws.ec2"]
    detail-type = ["EC2 Instance State-change Notification"]
  })
}

resource "aws_cloudwatch_event_target" "ec2_instance_status_change_event_target" {
  rule           = aws_cloudwatch_event_rule.ec2_instance_status_change_event_rule.name
  target_id      = var.api_destination_name
  arn            = var.api_destination_arn
  role_arn       = var.api_destinations_role_arn
  event_bus_name = var.event_bus_name

  input_transformer {
    input_paths = {
      accountId  = "$.detail.userIdentity.accountId"
      region     = "$.region"
      instanceId = "$.detail.instance-id"
      status     = "$.detail.state"
    }
    input_template = jsonencode({
      resource_type = "AWS::EC2::Instance"
      accountId     = "<accountId>"
      awsRegion     = "<region>"
      identifier    = "<instanceId>"
      eventName     = "if <status> == 'terminated' then 'delete' else 'upsert' end"
    })
  }
}