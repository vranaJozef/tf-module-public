module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 12.2"

  cluster_name    = var.cluster_name
  cluster_version = "1.18"
  subnets         = var.private_subnets
  vpc_id          = var.vpc_id

  worker_groups = [
    {
      instance_type = var.machine_type
    }
  ]

  map_users = var.map_users
}


