provider "aws" {
  region = "us-east-1"
}

# Create a VPC (Virtual Private Cloud)
resource "aws_vpc" "checkpoint_vpc" {
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
#create private subnet 1
resource "aws_subnet" "private_subnet1"{
  vpc_id                  = aws_vpc.checkpoint_vpc.id
  cidr_block              = "10.0.2.0/24"  # Adjust the CIDR block as needed
  availability_zone      = "us-east-1a"   # Change this to the desired AZ in your region
  map_public_ip_on_launch = true
  tags = {
    Name = "Private Subnet1"
  }
}
#create private subnet 2
resource "aws_subnet" "private_subnet2"{
  vpc_id                  = aws_vpc.checkpoint_vpc.id
  cidr_block              = "10.0.3.0/24"  # Adjust the CIDR block as needed
  availability_zone      = "us-east-1b"   # Change this to the desired AZ in your region
  map_public_ip_on_launch = true
  tags = {
    Name = "Private Subnet2"
  }
}
#create private subnet 3
resource "aws_subnet" "private_subnet3"{
  vpc_id                  = aws_vpc.checkpoint_vpc.id
  cidr_block              = "10.0.4.0/24"  # Adjust the CIDR block as needed
  availability_zone      = "us-east-1a"   # Change this to the desired AZ in your region
  map_public_ip_on_launch = true
  tags = {
    Name = "Private Subnet3"
  }
}
#create private subnet 4
resource "aws_subnet" "private_subnet4"{
  vpc_id                  = aws_vpc.checkpoint_vpc.id
  cidr_block              = "10.0.5.0/24"  # Adjust the CIDR block as needed
  availability_zone      = "us-east-1b"   # Change this to the desired AZ in your region
  map_public_ip_on_launch = true
  tags = {
    Name = "Private Subnet4"
  }
}


# Create a security group
resource "aws_security_group" "public_subnetSG" {
  vpc_id     = aws_vpc.checkpoint_vpc.id
  name_prefix = "checkpoint-sg"
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

resource "aws_key_pair" "my_key_pair" {
  key_name   = "my-keypair" 
  public_key = file("~/.ssh/id_rsa.pub") 
}

# Create AWS instance
resource "aws_instance" "pubsub1_instance" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet1.id
  key_name      = aws_key_pair.my_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.public_subnetSG.id]
  associate_public_ip_address = true
  
  tags = {
    Name = "pubsub1Instance"
  }
}
resource "aws_instance" "pubsub2_instance" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet2.id
  key_name      = aws_key_pair.my_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.public_subnetSG.id]
  associate_public_ip_address = true
  
  tags = {
    Name = "pubsub2Instance"
  }
}

resource "aws_security_group" "private_subnetSG" {
  vpc_id     = aws_vpc.checkpoint_vpc.id
  name_prefix = "checkpoint-sg"
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
resource "aws_instance" "privsub1_instance" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private_subnet1.id
  key_name      = aws_key_pair.my_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.private_subnetSG.id]
  associate_public_ip_address = true
  
  tags = {
    Name = "privsub1Instance"
  }
}
resource "aws_instance" "privsub2_instance" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private_subnet2.id
  key_name      = aws_key_pair.my_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.private_subnetSG.id]
  associate_public_ip_address = true
  
  tags = {
    Name = "privsub2Instance"
  }
}
resource "aws_instance" "privsub3_instance" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private_subnet1.id
  key_name      = aws_key_pair.my_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.private_subnetSG.id]
  associate_public_ip_address = true
  
  tags = {
    Name = "privsub3Instance"
  }
}
resource "aws_instance" "privsub4_instance" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private_subnet2.id
  key_name      = aws_key_pair.my_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.private_subnetSG.id]
  associate_public_ip_address = true
  
  tags = {
    Name = "privsub4Instance"
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.checkpoint_vpc.id
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.checkpoint_vpc.id
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
}

resource "aws_route_table_association" "public_route_association" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.public_route_table.id
}
resource "aws_route_table_association" "public_route_association2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public_route_table.id
}
# resource "aws_eip" "nat_gateway_eip" {
#   vpc = true
# }
# resource "aws_eip" "nat_gateway_eip2" {
#   vpc = true
# }
# resource "aws_nat_gateway" "example_nat_gateway" {
#   allocation_id = aws_eip.nat_gateway_eip.id
#   subnet_id     = aws_subnet.public_subnet1.id
# }
# resource "aws_nat_gateway" "example_nat_gateway2" {
#   allocation_id = aws_eip.nat_gateway_eip2.id
#   subnet_id     = aws_subnet.public_subnet2.id
# }

# resource "aws_route_table" "private_route_table" {
#   vpc_id = aws_vpc.checkpoint_vpc.id
# }
# resource "aws_route_table" "private_route_table2" {
#   vpc_id = aws_vpc.checkpoint_vpc.id
# }

# resource "aws_route" "private_route1" {
#   route_table_id         = aws_route_table.private_route_table.id
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id         = aws_nat_gateway.example_nat_gateway.id
# }
# resource "aws_route" "private_route2" {
#   route_table_id         = aws_route_table.private_route_table2.id
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id         = aws_nat_gateway.example_nat_gateway2.id
# }

# resource "aws_route_table_association" "private_route_association" {
#   subnet_id      = aws_subnet.private_subnet1.id
#   route_table_id = aws_route_table.private_route_table.id
# }
# resource "aws_route_table_association" "private_route_association2" {
#   subnet_id      = aws_subnet.private_subnet2.id
#   route_table_id = aws_route_table.private_route_table2.id
# }
