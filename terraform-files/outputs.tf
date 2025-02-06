output "application_url" {
  value = "http://${aws_eip.web_eip.public_ip}"
}