variable "db_user" {}
variable "db_pass" {}
variable "allow_ssh_cidr_for_ecs" {}
variable "alb_certificate_arn"    {}

provider "aws" {
  profile = "default"
  region  = var.region
}

module "base" {
  source = "./base"

  project = var.project
  region  = var.region
  db_user = var.db_user
  db_pass = var.db_pass

  alb_certificate_arn    = var.alb_certificate_arn
  allow_ssh_cidr_for_ecs = var.allow_ssh_cidr_for_ecs
}

////TODO: not terraform conversion.
//contaienr:
//  - ecs
//  - rcr
//  - task-definition
//
//auto-scalign:
//  - auto-scaling
//  - elastic-ip-relation
//
//contents-deliver:
//  - s3
//  - cloud-font
//
//route:
//  - route53
//
//ssl:
//  - acm