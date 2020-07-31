resource "aws_iam_role" "ecs" {
  assume_role_policy = file("${path.module}/role_policies/ecs_assume_role_policy.json")
  name = "${var.project}_ecs"
}

resource "aws_iam_role" "execution" {
  assume_role_policy = data.template_file.execution_assume_role_policy.rendered
  name = "${var.project}_execution"
}

data "template_file" "execution_assume_role_policy" {
  template = file("${path.module}/role_policies/execution_assume_role_policy.json")

  vars = {
    region = var.region
  }
}

resource "aws_iam_role_policy_attachment" "ecs_service" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
  role       = aws_iam_role.ecs.id
}

resource "aws_iam_role_policy_attachment" "ecs_task" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecs.id
}

resource "aws_iam_role_policy_attachment" "ecr_power_user" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
  role       = aws_iam_role.ecs.id
}

data "aws_iam_policy_document" "autoscaling-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["application-autoscaling.amazonaws.com"]
    }
  }
}