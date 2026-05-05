output "instance_id" {
  value = module.ec2_complete.id
}

output "public_ip" {
  value = module.ec2_complete.public_ip
}

output "private_ip" {
  value = module.ec2_complete.private_ip
}
