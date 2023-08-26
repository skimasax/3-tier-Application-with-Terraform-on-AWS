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
  vpc_id                  = aws_vpc.checkpoint_vpc.id
  cidr_block              = "10.0.0.0/24"  # Adjust the CIDR block as needed
  availability_zone      = "us-east-1a"   # Change this to the desired AZ in your region
  map_public_ip_on_launch = true
  tags = {
    Name = "Public Subnet1"
  }
}

#create public subnet 2
resource "aws_subnet" "public_subnet2"{
  vpc_id                  = aws_vpc.checkpoint_vpc.id
  cidr_block              = "10.0.1.0/24"  # Adjust the CIDR block as needed
  availability_zone      = "us-east-1b"   # Change this to the desired AZ in your region
  map_public_ip_on_launch = true
  tags = {
    Name = "Public Subnet2"
  }
}
