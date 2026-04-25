output "public_ip" {
  value = aws_instance.docker_ec2.public_ip
}