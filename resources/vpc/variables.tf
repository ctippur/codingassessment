variable "private_subnet_cidr" {
   default=[]
}

variable "aws_region" {
   description = "aws region"
}

variable "vpc_cidr" {
   description = "VPC cidr"
}

variable "public_subnet_cidr" { 
   default=[]
}

variable "azs" { 
   default=["us-west-2a","us-west-2b","us-west-2c"]
}
