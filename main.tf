provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_security_group" "allow_http" {
  name = "allow_http_v2"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["102.32.42.63/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "docker_ec2" {
  ami           = "ami-0f18986364089c4ab"
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.allow_http.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install docker -y
              service docker start
              usermod -a -G docker ec2-user

              docker run -d -p 80:80 nginx
              EOF

  tags = {
    Name = "Docker-EC2"
  }
}