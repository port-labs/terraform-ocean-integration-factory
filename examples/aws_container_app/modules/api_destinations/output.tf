output "api_destination" {
  value = aws_cloudwatch_event_api_destination.api_destination
}

output "api_destinations_role" {
  value = aws_iam_role.api_destinations_role
}

output "eventbus" {
  value = aws_cloudwatch_event_bus.eventbus
}