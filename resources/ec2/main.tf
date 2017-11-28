resource "aws_launch_configuration" "as_conf_apache" {
  name_prefix          = "lc-apache"
  image_id      = "${var.ami}"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.deployer.key_name}"
  user_data = "${file("../../scripts/create_apache.sh")}"
  associate_public_ip_address = "true"
  security_groups = ["${var.private_security_group}"]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "as_conf_nginx" {
  name_prefix          = "lc-nginx"
  image_id      = "${var.ami}"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.deployer.key_name}"
  user_data = "${file("../../scripts/create_nginx.sh")}"
  associate_public_ip_address = "true"
  security_groups = ["${var.private_security_group}"]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC2xtUcJVXqQkC3AHAcu+W0qCn+wGwOImUIaho4YkL9bAsW8fH1nnIcMdq2OjhH7nR48xbP/MIxRu5z4olL40+P5veyvdX0j4+z/61jXbWahLqBdEUh7j8zYBSMkM0lK/gLR/25mNvz+2OhOrLa1NVYit4IrcrvXhHpiHwEKpqbqjXQ8oU9xb9PwF39FDhXmO+dDL3OQruunAqv3SEzXaJq6EqYBFhYDCQGrWu5lx3q1Frpf+snnwioUQyyTwwTlqhlmXsju+WxpUFTR2N6FZQZRwwhf73eDEQSgFtGS9cpGbW2ylzFwyxvWNTEzYjP0xHwN67Z7rQlUYkjQSrh7fZT ctippur@SDGL1539037cf.local"
}

resource "aws_autoscaling_policy" "policy_apache" {
  name                   = "asg_policy_apache"
  scaling_adjustment     = 25
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.asg_resource_apache.name}"
}

resource "aws_autoscaling_policy" "policy_nginx" {
  name                   = "asg_policy_nginx"
  scaling_adjustment     = 25
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.asg_resource_nginx.name}"
}

resource "aws_autoscaling_group" "asg_resource_apache" {
  availability_zones        = ["${var.azs[0]}", "${var.azs[1]}"]
  name                      = "auto_scaling_group_apache"
  max_size                  = 4
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  force_delete              = true
  launch_configuration      = "${aws_launch_configuration.as_conf_apache.name}"
  vpc_zone_identifier       =  ["${var.public_subnets}"]
  
}

resource "aws_autoscaling_group" "asg_resource_nginx" {
  availability_zones        = ["${var.azs[2]}"]
  name                      = "auto_scaling_group_nginx"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  force_delete              = true
  launch_configuration      = "${aws_launch_configuration.as_conf_nginx.name}"
  vpc_zone_identifier       =  ["${var.public_subnets}"]
}

resource "aws_autoscaling_attachment" "asg_attachment_apache" {
  autoscaling_group_name = "${aws_autoscaling_group.asg_resource_apache.id}"
  elb                    = "${var.elb}"
}
resource "aws_autoscaling_attachment" "asg_attachment_nginx" {
  autoscaling_group_name = "${aws_autoscaling_group.asg_resource_nginx.id}"
  elb                    = "${var.elb}"
}
