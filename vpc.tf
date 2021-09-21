//module "vpc" {
//  source  = "terraform-aws-modules/vpc/aws"
//  version = "~> 2.48"
//
//  name = var.vpc_name
//  cidr = "10.0.0.0/16"
//
//  azs                  = slice(data.aws_availability_zones.azs.names, 0, 2)
//  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24"]
//  public_subnets       = ["10.0.3.0/24", "10.0.4.0/24"]
//  enable_nat_gateway   = true
//  single_nat_gateway   = true
//  enable_dns_hostnames = true
//
//  tags = {
//    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
//  }
//
//  public_subnet_tags = {
//    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
//    "kubernetes.io/role/elb"                      = "1"
//  }
//
//  private_subnet_tags = {
//    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
//    "kubernetes.io/role/internal-elb"             = "1"
//  }
//}
//
//data "aws_availability_zones" "azs" {
//  state = "available"
//}

//resource "aws_vpc" "vpc" {
//  cidr_block           = "10.0.0.0/16"
//  enable_dns_hostnames = true
//
//  tags = {
//    Name = "EFS-Mount-Demo"
//  }
//}
//
//resource "aws_subnet" "sub" {
//  cidr_block = "10.0.0.0/24"
//  vpc_id     = aws_vpc.vpc.id
//
//  tags = {
//    Name = "EFS-Mount-Demo"
//  }
//}