provider "aws" {
  profile = "default"
  region  = "ap-northeast-1"
}

resource "aws_instance" "sample" {
  ami           = "ami-0a1c2ec61571737db"
  instance_type = "t2.micro"
}

resource "aws_eip" "ip" {
  vpc = true
  instance = aws_instance.example.id
}