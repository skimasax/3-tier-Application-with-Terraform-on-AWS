provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "static_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.static_vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone      = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_subnet2" {
  vpc_id                  = aws_vpc.static_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone      = "us-east-1b"
  map_public_ip_on_launch = true
}

resource "aws_security_group" "staticSG" {
  vpc_id     = aws_vpc.static_vpc.id
  name_prefix = "checkpoint-sg"
  description = "Checkpoint security group"

  # Ingress and egress rules here
   ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_key_pair" "my_key_pair" {
  key_name   = "my-keypair"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "staticInstance" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  key_name      = aws_key_pair.my_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.staticSG.id]
  associate_public_ip_address = true

  tags = {
    Name = "staticWebsiteInstance1"
  }
}

resource "aws_instance" "staticInstance2" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet2.id
  key_name      = aws_key_pair.my_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.staticSG.id]
  associate_public_ip_address = true

  tags = {
    Name = "staticWebsiteInstance2"
  }
}

resource "aws_lb" "static_alb" {
  name               = "static-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.public_subnet.id, aws_subnet.public_subnet2.id]
}

resource "aws_lb_target_group" "static_target_group" {
  name     = "static-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.static_vpc.id

  health_check {
    path        = "/"
    protocol    = "HTTP"
    interval    = 30
    timeout     = 5
    healthy_threshold = 5
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "example_listener_rule" {
  listener_arn = aws_lb.static_alb.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.static_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.static_vpc.id
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.static_vpc.id
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
}

resource "aws_route_table_association" "public_route_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_route_association2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public_route_table.id
}
