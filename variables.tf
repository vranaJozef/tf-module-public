## Cluster variables

variable "region" {
  description = "Region of the GKE"
  default = "us-east-2"
}

variable "cluster_name" {
  default = "pcs-prod"
}

variable "machine_type" {
  description = "Machine type. Tested with selected default."
  default = "m5.4xlarge"
}

variable "vpc_name" {
  description = "VPC name"
  default = "inzata-vpc-c5.9xlarge"
}

variable "vpc_id" {
  default = "vpc-0efea464cca7e15c6"
}

variable "private_subnets" {
  default = ["subnet-0448b4992e67c23c7","subnet-0e86eceef3190ae97"]
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      userarn  = "arn:aws:iam::813784848416:user/vasekd"
      username = "vasek"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::813784848416:user/jozef"
      username = "jozef"
      groups   = ["system:masters"]
    },
  ]
}

## Docker registry

variable "docker-username" {
  description = "Docker username provided by InZata team."
  default = "AWS_Terraform"
}

variable "docker-password" {
  description = "Docker password provided by InZata team."
  default = "_M_gtuW6k73bsfzAzWp3"
}

variable "docker-server" {
  description = "Docker registry server provided by InZata team."
  default = "registry.inzata.com"
}

## IzChart values

variable "backupSuspend" {
  description = ""
  default = true
}

variable "backupSchedule" {
  description = ""
  default = "* 21 * * *"
}

variable "iz_version" {
  description = "Version of IzChart."
  default = "master-9608"
}
variable "iz_timeout" {
  description = "Timeout in seconds for Terraform to wait for resource."
  default = "3000" // seconds
}

variable "ssl_mail" {
  description = "Let's Encrypt will use this to contact you about expiring certificates, and issues related to your account."
  default = "admin@inzata.com"
}

variable "ssl_domain" {
  description = "Domain for access to InZata platform."
  default = "pcs.aws.inzata.com"
}

variable "auth0cliendID" {
  description = "Client ID for auth0. Provided by InZata team."
  default = "0ShPHyV1d8lgbWab7z4vkkEqIEddnqBT"
}

variable "auth0secret" {
  description = "Secret for auth0. Provided by InZata team."
  default = "_nM29H-ev-P18tM-4XfomCyges0VTvJYakjWhpX9RkRVsFaEyzAnNBXEjBQfbv4V"
}
