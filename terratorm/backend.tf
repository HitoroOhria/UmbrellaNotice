terraform {
  backend "s3" {
    bucket  = "umbrellanotice-terraform-pro"
    key     = "unbrellanotice.terraform.pro.tfstate"
    region  = "ap-northeast-1"
    profile = "default"
  }
}