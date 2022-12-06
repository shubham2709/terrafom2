resource "aws_security_group" "apache" {
  name        = "allow_apache"
  description = "Allow apache inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description     = "SSH from Admin"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.baston.id]

  }

  ingress {
    description     = "For alb endusers"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name      = "Stage-apache-sg",
    Terraform = "true"
  }
}

resource "aws_instance" "apache" {
  ami           = "ami-0b89f7b3f054b957e"
  instance_type = "t2.micro"
   vpc_id = aws_vpc.vpc.id  
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.apache.id]
  user_data =        <<- EOF
		#! /bin/bash
                #!/bin/bash
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum upgrade
# Add required dependencies for the jenkins package
sudo yum install java-11-openjdk
sudo yum install jenkins 
sudo systemctl daemon-reload
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins
	EOF
s
  tags = {
    Name = "Stage-apache"
  }
}

