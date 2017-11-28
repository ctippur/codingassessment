provider "aws" {
  profile = "learning70"
  region     = "us-west-2"
}
terraform {
  backend "s3" {
    bucket = "tf-td-shekar-l70"
    key    = "td/terraform.tfstate"
  }
  profile = "learning70"
  region  = "${var.aws_region}"
}

module "vpc" {
    source = "../../resources/vpc"
    aws_region = "${var.aws_region}"
    public_subnet_cidr = "${var.public_subnet_cidr}"
    private_subnet_cidr = "${var.private_subnet_cidr}"
    vpc_cidr = "${var.vpc_cidr}"

}

module "elb" {
  source = "../../resources/elb"
  vpcid="${module.vpc.vpcid}"
  public_security_group="${module.vpc.public_security_group}"
  public_subnet_cidr = "${var.public_subnet_cidr}"
  public_subnets = "${module.vpc.public_subnets}"
  azs="${var.azs["${var.aws_region}"]}"
  apache_webservers="${module.ec2.apache_webservers}"
  nginx_webservers="${module.ec2.nginx_webservers}"
}

module "ec2" {
  source = "../../resources/ec2"
  azs="${var.azs["${var.aws_region}"]}"
  ami="${var.ami["${var.aws_region}"]}"
  aws_region = "${var.aws_region}"
  public_subnets = "${module.vpc.public_subnets}"
  private_security_group = "${module.vpc.private_security_group}"
  elb="${module.elb.elb}"
}


#module "base" {
#    source = "../../resources/base"
#    aws_region = "${var.aws_region}"
#}
#output "vpcid" {
#  value = "${aws_vpc.main.id}"
#}
#output "cidr_block" {
#  value = "${aws_vpc.main.cidr_block}"
#}
#output "private_security_group" {
#  value= "${aws_security_group.private_security_group}"
#}
#output "public_security_group" {
#  value= "${aws_security_group.public_security_group}"
#}

