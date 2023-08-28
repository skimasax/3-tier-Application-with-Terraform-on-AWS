output "static_vpc"{
    value=aws_vpc.static_vpc
}
output "publicsubnet"{
    value=aws_subnet.public_subnet
}
# Output the ALB DNS name
output "alb_dns_name" {
  value = aws_lb.static_alb.dns_name
}