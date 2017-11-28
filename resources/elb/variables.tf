variable "public_security_group" {
    description = "all az groups"
}
variable "azs" {
    description = "all az groups"
    default=[]
}
variable "vpcid" {
    description = "vpcid"
}
variable "public_subnet_cidr" {
    description = "vpcid"
    default = []
}
variable "apache_webservers" {
    default=[]
}
variable "nginx_webservers" {
    default=[]
}
variable "public_subnets" {
    description = "public subnets"
    default = []
}
