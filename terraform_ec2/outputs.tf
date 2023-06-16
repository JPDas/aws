output "public_ip" {
  value = aws_instance.my_example.public_ip
}

output "instance_id" {
  value = aws_instance.my_example.id
}