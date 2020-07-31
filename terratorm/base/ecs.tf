//resource "aws_ecs_cluster" "this" {
//  name = "${var.project}-pro"
//  capacity_providers = [aws_ecs_capacity_provider.this.name]
//  default_capacity_provider_strategy {
//    base              = 0
//    capacity_provider = aws_ecs_capacity_provider.this.name
//    weight            = 1
//  }
//}

//resource "aws_ecs_capacity_provider" "this" {
//  name = "${var.project}-pro"
//
//  auto_scaling_group_provider {
//    auto_scaling_group_arn         = aws_autoscaling_group.this.arn
//    managed_termination_protection = "ENABLED"
//
//    managed_scaling {
//      maximum_scaling_step_size = 100
//      minimum_scaling_step_size = 1
//      status                    = "ENABLED"
//      target_capacity           = 10
//    }
//  }
//}

//resource "aws_ecs_service" "backend" {
//  name            = "${var.project}-backend"
//  cluster         = aws_ecs_cluster.this.id
//  task_definition = aws_ecs_task_definition.mongo.arn
//  desired_count   = 1
//  iam_role        = aws_iam_role.ecs.arn
//  depends_on      = ["aws_iam_role_policy.iam_role"]
//
//  ordered_placement_strategy {
//    type  = "binpack"
//    field = "cpu"
//  }

//  load_balancer {
//    target_group_arn = aws_alb_target_group.target_group.arn
//    container_name   = "nginx"
//    container_port   = 443
//  }
//
//  placement_constraints {
//    type       = "memberOf"
//    expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
//  }
//}

//resource "aws_ecs_service" "sidekiq" {
//  name            = "${var.project}-sidekiq"
//  cluster         = aws_ecs_cluster.ecs_cluster.id
//  task_definition = aws_ecs_task_definition.mongo.arn
//  desired_count   = 1
//}

//# タスク定義をコード管理すると、CircleCIデプロイが使えなくなる事件
//resource "aws_ecs_task_definition" "backend" {
//  family                = "backend"
//  container_definitions = [file("./task-definitions/rails.json"), file("./task-definitions/nginx.json")]
//
//  volume {
//    name      = "service-storage"
//    host_path = "/ecs/service-storage"
//  }
//
//  placement_constraints {
//    type       = "memberOf"
//    expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
//  }
//}

