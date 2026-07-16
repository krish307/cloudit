output "ubuntu_ami_id" {
  description = "Ubuntu AMI selected dynamically by Terraform"
  value       = data.aws_ami.ubuntu.id
}

output "security_group_id" {
  description = "CloudIt Security Group ID"
  value       = aws_security_group.cloudit_sg.id
}

output "instance_id" {
  description = "CloudIt EC2 instance ID"
  value       = aws_instance.cloudit_server.id
}

output "public_ip" {
  description = "Public IPv4 address of the CloudIt server"
  value       = aws_instance.cloudit_server.public_ip
}

output "public_dns" {
  description = "Public DNS name of the CloudIt server"
  value       = aws_instance.cloudit_server.public_dns
}

output "website_url" {
  description = "CloudIt website URL"
  value       = "http://${aws_instance.cloudit_server.public_ip}"
}

output "ssh_command" {
  description = "Example SSH connection command"
  value       = "ssh -i cloud-web-key.pem ubuntu@${aws_instance.cloudit_server.public_ip}"
}