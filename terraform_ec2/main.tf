provider "aws" {
  region     = var.region
  access_key = "AKIATNHOIVSE6EDLHZT4"
  secret_key = "DpuX2TuVaM/IJg6dXoXnXK9zmCySQtFFuKyLS/ns"
}

resource "aws_instance" "my_example" {
  ami           = var.ami
  instance_type = var.instance_type
  tags = {
    Name = "my_terraform_server"
  }
}