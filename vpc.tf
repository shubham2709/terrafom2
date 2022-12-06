resource "aws_vpc" "dev-vpc" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_hostnames = true
  instance_tenancy     = "default"


  tags = {
    Name      = "shubhamvpc"
    Terraform = "true"
  }
}