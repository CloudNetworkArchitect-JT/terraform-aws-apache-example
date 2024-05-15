provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

data "aws_vpc" "main" {
  id = var.vpc_id
}
data "aws_subnet" "subnet_ids" {
  vpc_id = data.aws_vpc.main.id

  filter {
    name   = "tag:Environment"
    values = ["dev"]
  }
  filter {
    name   = "tag:Name"
    values = ["my-vpc-public-us-east-1a"]
  }
}

resource "aws_security_group" "sg_my_server" {
  name        = "sg_my_server"
  description = "MyServer Security Group"
  vpc_id      = data.aws_vpc.main.id

  ingress = [
    {
      description      = "HTTP"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = [var.my_ip]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress = [
    {
      description      = "outgoing traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
}

resource "aws_key_pair" "deployer" {
  key_name   = "id_rsa.pub"
  public_key = var.public_key
}

data "template_file" "user_data" {
  template = file("${abspath(path.module)}/userdata.yaml")
}

resource "aws_instance" "my_server" {
  ami       = data.aws_ami.amazon-linux-2.id
  subnet_id = data.aws_subnet.subnet_ids.id
  # modified the previous aws_subnet_ids deprecated data source and replaced it with the its intended replacement aws_subnet

  # This fix resolution is associated to the reported issue https://github.com/hashicorp/terraform-provider-aws/issues/20592 
  instance_type          = var.instance_type
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.sg_my_server.id]
  user_data              = data.template_file.user_data.rendered

  tags = {
    name = var.server_name
  }
}


