output "app_server_public_ip" {
  description = "Public IP of the Flask app EC2 instance"
  value       = module.app_server.public_ip
}

output "app_url" {
  description = "URL to access the Flask app"
  value       = "http://${module.app_server.public_ip}:5000"
}

output "jenkins_url" {
  description = "URL to access Jenkins"
  value       = "http://${module.app_server.public_ip}:8080"
}
