########### content for instance.tf #######################

resource "aws_instance" "ntp_server" {
  ami           = "ami-08c2ee02329b72f26"
  instance_type = "t2.micro"
  key_name = "nso_key"
  vpc_security_group_ids = ["${aws_security_group.allow_tls.id}"]
  user_data = "${file("user_data.sh")}"
  tags = {
    Name = "first-terraform-instance"
  }
}

########### content for provider.tf #######################

provider "aws" {
  region     = "ap-northeast-3"
  access_key = ""
  secret_key = ""

} 


resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  dynamic "ingress" {
    for_each = [80,8080,443,9090,22]
    iterator = port
    content {
      description = "TLS from VPC"
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

