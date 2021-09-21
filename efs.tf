//module "efs-0" {
//  source = "cloudposse/efs/aws"

  #count = length(module.vpc.public_subnets)
//  name = "efs-example"
  #subnet_ids = element(module.vpc.public_subnets, count.index)
//  vpc_id = module.vpc.vpc_id
//
//  depends_on = [module.vpc, module.eks]
//  region = var.region
//  security_groups = [module.vpc.default_security_group_id]
//  subnets = module.vpc.public_subnets
//}

//resource "aws_efs_file_system" "efs-example" {
//  creation_token = "efs-example"
//  performance_mode = "generalPurpose"
//  throughput_mode = "bursting"
//  encrypted = "true"
//  tags = {
//    Name = "EfsExample"
//  }
//
//  depends_on = [module.eks]
//}
//
//resource "aws_efs_mount_target" "efs-mt-example" {
//  count = length(module.vpc.public_subnets)
//  file_system_id  = aws_efs_file_system.efs-example.id
//  subnet_id = element(module.vpc.public_subnets, count.index)
//  security_groups = [aws_security_group.efs-sg.id]
//}
//
//data "aws_efs_file_system" "data" {
//  file_system_id = aws_efs_file_system.efs-example.id
//}
//
//resource "aws_security_group" "efs-sg" {
//  vpc_id      = module.vpc.vpc_id
//  description = "EFS-EC2 Access Security Group"
//
//  tags = {
//    Name = "EFS-Mount-Demo"
//  }
//}
//
//resource "aws_security_group_rule" "efs-sg-rule-ingress" {
//  description       = "Ingress rule to allow traffic to EFS"
//  from_port         = 2049
//  protocol          = "TCP"
//  security_group_id = aws_security_group.efs-sg.id
//  to_port           = 2049
//  type              = "ingress"
//  self              = true
//}
//
//resource "aws_security_group_rule" "efs-sg-rule-egress" {
//  description       = "Egress rule to to allow traffic from instances to EFS"
//  from_port         = 2049
//  protocol          = "TCP"
//  security_group_id = aws_security_group.efs-sg.id
//  to_port           = 2049
//  type              = "egress"
//  self              = true
//}
//
//resource "aws_efs_file_system_policy" "policy" {
//  file_system_id = aws_efs_file_system.efs-example.id
//
//  policy = <<POLICY
//{
//    "Version": "2012-10-17",
//    "Id": "ExamplePolicy01",
//    "Statement": [
//        {
//            "Sid": "ExampleSatement01",
//            "Effect": "Allow",
//            "Principal": {
//                "AWS": "*"
//            },
//            "Resource": "${aws_efs_file_system.efs-example.arn}",
//            "Action": [
//                "elasticfilesystem:ClientMount",
//                "elasticfilesystem:ClientWrite"
//            ],
//            "Condition": {
//                "Bool": {
//                    "aws:SecureTransport": "true"
//                }
//            }
//        }
//    ]
//}
//POLICY
//}