provider "aws"{
    region = "us-east-1a"
}

resource "aws_vpc" "bimbo_vpc"{
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}