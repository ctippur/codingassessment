output "apache_webservers" {
  #value = "${join(",",aws_autoscaling_group.asg_resource_apache.*.id)}"
  value = ["${aws_autoscaling_group.asg_resource_apache.*.id}"]
}
output "nginx_webservers" {
  value = ["${aws_autoscaling_group.asg_resource_nginx.*.id}"]
  #value = "${join(",",aws_autoscaling_group.asg_resource_nginx.*.id)}"
}
