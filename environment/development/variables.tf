#variable "aws_access_key" {}
#variable "aws_secret_key" {}
#variable "aws_key_path" {}
#variable "aws_key_name" {}

variable "aws_region" {
    description = "EC2 Region for the VPC"
    default = "us-west-2"
}

variable "environment" {
  default="dev"
}

variable "azs" {
  default = { 
    "us-east-1" = ["us-east-1a","us-east-1b","us-east-1c"]
    "us-west-2" = ["us-west-2a","us-west-2b", "us-west-2c"]
  }
}

variable "ami" {
    description = "AMIs by region"
    default = {
        "us-east-1" = "ami-5e63d13e" # ubuntu 14.04 LTS
        "us-west-2" = "ami-5e63d13e" # ubuntu 14.04 LTS
    }
}

variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
    description = "CIDR for the Public Subnet"
    default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidr" {
    description = "CIDR for the Private Subnet"
    default = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}
