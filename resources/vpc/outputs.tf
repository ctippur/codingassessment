output "vpcid" {
  value = "${aws_vpc.main.id}"
}
output "cidr_block" {
  value = "${aws_vpc.main.cidr_block}"
}
output "private_security_group" {
  value= "${aws_security_group.private_security_group.id}"
}
output "public_security_group" {
  value= "${aws_security_group.public_security_group.id}"
}
output "public_subnets" {
  value=["${aws_subnet.public.*.id}"]
}
