provider "aws" {
  region     = var.region
}

resource "aws_instance" "my_example" {
  ami           = var.ami
  instance_type = var.instance_type
  tags = {
    Name = "my_terraform_server"
  }
}