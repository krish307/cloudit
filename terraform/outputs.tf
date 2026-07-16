output "instance_id" {
  value = aws_instance.cloudit_server.id
}

output "public_ip" {
  value = aws_instance.cloudit_server.public_ip
}

output "public_dns" {
  value = aws_instance.cloudit_server.public_dns
}