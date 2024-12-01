variable "vpc_name" {
  type        = string
  description = "Name to be used on all the VPC resources as identifier"
  default     = "cis-vpc"
}

variable "region" {
  default     = "us-west-2"
}

variable "sg_name" {
  type        = string
  description = "Name of security group"
  default     = "cis-sg"
}

variable "vpc_cidr" {
  type        = string
  description = "The CIDR block for the VPC"
  default     = "10.1.0.0/16"
}

variable "vpc_private_subnet" {
  type        = string
  description = "Private subnet inside the VPC. Use for EC2 instance"
  default     = "10.1.3.0/24"
}

variable "vpc_public_subnet" {
  type        = string
  description = "Public subnets inside the VPC. Used for NAT Gateway"
  default     = "10.1.2.0/24"
}

variable "instance_type" {
  type        = string
  description = "The type of instance to start"
  default     = "t2.micro"
}

variable "instance_name" {
  type        = string
  description = "Name to be used on all EC2 resources as prefix"
  default     = "cis-ami-instance"
}
