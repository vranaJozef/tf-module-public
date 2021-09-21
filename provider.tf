provider "aws" {
	region     = var.region
	shared_credentials_file = "${path.cwd}/Credentials"
}

## Use helm provider for helm_release to work

provider "helm" {
	## This is required for helm provider

	kubernetes {
		host                   = data.aws_eks_cluster.cluster.endpoint
		cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
		token                  = data.aws_eks_cluster_auth.cluster.token
	}
}

## Required for access kubernetes cluster

provider "kubernetes" {
	host                   = data.aws_eks_cluster.cluster.endpoint
	cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
	token                  = data.aws_eks_cluster_auth.cluster.token
}

data "aws_eks_cluster" "cluster" {
	name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
	name = module.eks.cluster_id
}

terraform {
	backend "s3" {
		bucket = "pcs-prod-tf-state"
		region = "us-east-2"
		key = "terraform.tfstate"
	}
}


