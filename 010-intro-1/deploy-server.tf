# Reference: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#argument-reference
provider "aws" {
  region = var.region
}

# Reference: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "myvm1" {
  ami           = var.ami
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.myvm1sg.id]

  user_data = <<-EOF
                #!/bin/bash
                sudo yum install httpd -y
                sudo systemctl enable httpd --now
                echo "Welcome to Rathinam Trainers" | sudo tee /var/www/html/index.html
              EOF
  tags = var.tags
}

resource "aws_security_group" "myvm1sg" {
  name = "myvm1sg"
  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = var.ingress_source_cidr
  }
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = var.ingress_source_cidr
  }
  ingress {
    from_port = -1
    to_port   = -1
    protocol  = "icmp"
    cidr_blocks = var.ingress_source_cidr
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

