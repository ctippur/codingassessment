variable "aws_region" {
   description = "aws region"
}

variable "azs" {
   description = "Available AZs"
   default=[]
}

variable "ami" {
}
variable "elb" { 
}
variable "private_security_group" { 
  #default=[]
}
variable "public_subnets" {
    description = "public subnets"
    default = []
}
