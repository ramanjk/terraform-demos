# Reference: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#argument-reference
provider "aws" {
  region = "ap-south-1"
}

# Reference: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "myvm1" {
  ami           = "ami-079b5e5b3971bd10d"
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.myvm1sg.id]

  user_data = <<-EOF
                #!/bin/bash
                sudo yum install httpd -y
                sudo systemctl enable httpd --now
                echo "Welcome to Rathinam Trainers" | sudo tee /var/www/html/index.html
              EOF
  tags = {
    Name = "webserver1"
    Application = "CRM"
  }
}

resource "aws_security_group" "myvm1sg" {
  name = "myvm1sg"
  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

