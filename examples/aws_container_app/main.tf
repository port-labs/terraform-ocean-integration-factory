provider "aws" {
  profile = "port-admin"
  region  = "eu-west-1"
}

resource "aws_iam_role" "port_ocean_aws_integration_role" {
  name = "port-ocean-aws-integration-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com",
        },
        Action = "sts:AssumeRole",
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "port_ocean_aws_integration_task_execution_policy_attachment" {
  role       = aws_iam_role.port_ocean_aws_integration_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_cluster" "port_ocean_aws_integration_cluster" {
  name = "port-ocean-aws-integration-cluster"
}

resource "aws_ecs_task_definition" "port_ocean_aws_integration_task_definition" {
  family                   = "port_ocean_aws_integration"
  execution_role_arn       = aws_iam_role.port_ocean_aws_integration_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  cpu    = "256"
  memory = "512"


  container_definitions = jsonencode([
    {
      name  = "busybpx-demo"
      image = "busybox"
      "entryPoint" : [
        "sh",
        "-c"
      ],
      "command" : ["while true; do echo Hello World; sleep 1; done"],
      essential = true
    }
  ])
}

resource "aws_ecs_service" "port_ocean_aws_integration_service" {
  name            = "port-ocean-aws-integration-service"
  cluster         = aws_ecs_cluster.port_ocean_aws_integration_cluster.id
  task_definition = aws_ecs_task_definition.port_ocean_aws_integration_task_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnets
    security_groups = []
  }
}