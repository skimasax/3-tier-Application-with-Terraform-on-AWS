provider "aws"{
    region = "us-east-1a"
}

resource "aws_vpc" "bimbo_vpc"{
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

#create public subnet 1
resource "aws_subnet" "public_subnet1"{
  vpc_id                  = aws_vpc.bimbo_vpc.id
  cidr_block              = "10.0.0.0/24"  
  availability_zone      = "us-east-1a"  
  map_public_ip_on_launch = true
  tags = {
    Name = "Public Subnet1"
  }
}

#create public subnet 2
resource "aws_subnet" "public_subnet2"{
  vpc_id                  = aws_vpc.bimbo_vpc.id
  cidr_block              = "10.0.1.0/24"  
  availability_zone      = "us-east-1b"   
  map_public_ip_on_launch = true
  tags = {
    Name = "Public Subnet2"
  }
}

#create Private subnets
resource "aws_subnet" "private_subnet1"{
  vpc_id                  = aws_vpc.bimbo_vpc.id
  cidr_block              = "10.0.2.0/24"  
  availability_zone      = "us-east-1a"  
  map_public_ip_on_launch = true
  tags = {
    Name = "Private Subnet1"
  }
}
resource "aws_subnet" "private_subnet2"{
  vpc_id                  = aws_vpc.bimbo_vpc.id
  cidr_block              = "10.0.3.0/24"  
  availability_zone      = "us-east-1b" 
  map_public_ip_on_launch = true
  tags = {
    Name = "Private Subnet3"
  }
}
resource "aws_subnet" "private_subnet3"{
  vpc_id                  = aws_vpc.bimbo_vpc.id
  cidr_block              = "10.0.4.0/24"  
  availability_zone      = "us-east-1a"   
  map_public_ip_on_launch = true
  tags = {
    Name = "Private Subnet3"
  }
}
resource "aws_subnet" "private_subnet4"{
  vpc_id                  = aws_vpc.bimbo_vpc.id
  cidr_block              = "10.0.5.0/24"  
  availability_zone      = "us-east-1b"   
  map_public_ip_on_launch = true
  tags = {
    Name = "Private Subnet4"
  }
}


# Create a security group
resource "aws_security_group" "bimboSG" {
  vpc_id     = aws_vpc.bimbo_vpc.id
  name_prefix = "bimboPractise-sg"
  description = "Checkpoint security group"

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
}

#createKeypair
resource "aws_key_pair" "my_key_pair" {
  key_name   = "bimboPractise-keypair" 
  public_key = file("~/.ssh/id_rsa.pub") 
}