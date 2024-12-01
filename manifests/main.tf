module "vpc" {
  source                 = "terraform-aws-modules/vpc/aws"
  version                = "5.16.0"
  name                   = var.vpc_name
  cidr                   = var.vpc_cidr
  azs                    = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets        = [var.vpc_private_subnet]
  public_subnets         = [var.vpc_public_subnet]
  enable_dns_hostnames   = true
  enable_dns_support     = true
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
}

module "instance_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.2.0"
  vpc_id  = module.vpc.vpc_id
  name    = var.sg_name
  egress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

data "aws_ami" "ubuntu" {

  most_recent = true

  filter {
    name = "name"
    values = [
      "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"
    ]
  }

  filter {
    name = "virtualization-type"
    values = [
      "hvm"
    ]
  }

  owners = ["amazon"]
}

module "ec2_instance" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "5.7.1"
  name                        = var.instance_name
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  associate_public_ip_address = false
  user_data                   = <<-EOF
                                #!/bin/bash
                                curl -o /tmp/cis-hardening.sh https://raw.githubusercontent.com/AndyHS-506/Ubuntu-Hardening/refs/heads/main/hardening-24-04.sh && \
                                bash /tmp/cis-hardening.sh | tee /tmp/cis-hardening_output.log 2>&1
                                EOF
  subnet_id                   = module.vpc.private_subnets[0]
  vpc_security_group_ids = [
    module.instance_sg.security_group_id
  ]

  depends_on = [
    module.vpc,
    module.instance_sg
  ]
}

