
resource "aws_elb" "elb" {
  name = "elbpublic"
  security_groups = ["${var.public_security_group}"]
  subnets = ["${var.public_subnets}"]
  #availability_zones = ["${var.azs}"]
  #instances                   = ["${var.apache_webservers}","${var.nginx_webservers}"]
  listener {
    lb_port = 443
    lb_protocol = "https"
    instance_port = 8900
    instance_protocol = "http"
    ssl_certificate_id = "arn:aws:acm:us-west-2:712971639638:certificate/c9340634-2808-4273-9f67-4c37734b30ad"
  }

  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = 8900
    instance_protocol = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8900/"
    interval            = 30
  }
}
