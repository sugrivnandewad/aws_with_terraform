# EC2 module - outputs.tf
# Export EC2-related outputs
output "instance_ids" {
  description = "Map of logical instance name to EC2 instance ID"
  value       = { for k, v in aws_instance.this : k => v.id }
}

output "private_ips" {
  description = "Map of logical instance name to private IP address"
  value       = { for k, v in aws_instance.this : k => v.private_ip }
}

output "public_ips" {
  description = "Map of logical instance name to public IP address (empty string if none assigned)"
  value       = { for k, v in aws_instance.this : k => v.public_ip }
}

output "security_group_id" {
  description = "ID of the security group created for these instances"
  value       = aws_security_group.this.id
}

output "ami_id" {
  description = "AMI ID actually used to launch the instances (explicit or auto-resolved)"
  value       = local.ami_id
}