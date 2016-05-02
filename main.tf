/*
 * Module: tf_aws_sg_elb_lc_asg
 *
 * This template creates the following resources
 *    - 2 security groups
 *      - 1 Ingress -> allow all traffic in on port 80; Outbound -> only to security group 2
 *      - 1 Ingress -> from ELB security group on port 80; Inbound on port 22 from anywhere; Outbound -> wide open
 *    - A load balancer
 *    - A launch configuration
 *    - An auto-scale group
 *
 */

 module "bootstrap" {
   source       = "git::ssh://git@bitbucket.org/vgtf/argo-bootstrap-terraform.git?ref=v0.1.0"
   products     = "${var.emrl_products}"
   package_size = "${var.emrl_package_size}"
   customer     = "${var.tag_customer}"
 }

resource "aws_security_group" "sg_elb" {
  name          = "${var.tag_customer}-${var.tag_product}-${var.tag_environment}-tf-elb"
  vpc_id        = "${var.vpc_id}"

  # inbound HTTP access from anywhere
  ingress {
    from_port   = "${var.elb_listener_lb_port}"
    to_port     = "${var.elb_listener_lb_port}"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound only to items with the sg_instance security group
  egress {
    from_port   = "${var.elb_listener_instance_port}"
    to_port     = "${var.elb_listener_instance_port}"
    protocol    = "tcp"
    security_groups = ["${aws_security_group.sg_instance.id}"]
  }

  tags {
    Name        = "${var.tag_customer}-${var.tag_product}-${var.tag_environment}-tf-elb"
    Description = "${var.tag_description}"
    Environment = "${var.tag_environment}"
    Creator     = "${var.tag_creator}"
    Customer    = "${var.tag_customer}"
    Owner       = "${var.tag_owner}"
    Product     = "${var.tag_product}"
    Costcenter  = "${var.tag_costcenter}"
  }
 }

resource "aws_security_group" "sg_instance" {
  name          = "${var.tag_customer}-${var.tag_product}-${var.tag_environment}-tf-instance"
  vpc_id        = "${var.vpc_id}"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "${var.tag_customer}-${var.tag_product}-${var.tag_environment}-tf-instance"
    Description = "${var.tag_description}"
    Environment = "${var.tag_environment}"
    Creator     = "${var.tag_creator}"
    Customer    = "${var.tag_customer}"
    Owner       = "${var.tag_owner}"
    Product     = "${var.tag_product}"
    Costcenter  = "${var.tag_costcenter}"
  }
 }

resource "aws_elb" "elb" {
  depends_on          = ["aws_security_group.sg_elb"]
  name                = "${var.tag_customer}-${var.tag_product}-${var.tag_environment}-tf"
  security_groups     = ["${aws_security_group.sg_elb.id}"]
  subnets             = ["${split(",", var.vpc_zone_subnets)}"]

  listener {
    instance_port     = "${var.elb_listener_instance_port}"
    instance_protocol = "http"
    lb_port           = "${var.elb_listener_lb_port}"
    lb_protocol       = "http"
  }
  health_check {
    healthy_threshold   = "${var.elb_health_check_healthy_threshold}"
    unhealthy_threshold = "${var.elb_health_check_unhealthy_threshold}"
    timeout             = "${var.elb_health_check_timeout}"
    target              = "${var.elb_health_check_target}"
    interval            = "${var.elb_health_check_interval}"
  }

  tags {
    Name            = "${var.tag_name}"
    Description     = "${var.tag_description}"
    Environment     = "${var.tag_environment}"
    Creator         = "${var.tag_creator}"
    Customer        = "${var.tag_customer}"
    Owner           = "${var.tag_owner}"
    Product         = "${var.tag_product}"
    Costcenter      = "${var.tag_costcenter}"
  }
}

resource "aws_launch_configuration" "launch_config" {
  depends_on      = ["aws_security_group.sg_instance"]
  name_prefix     = "${var.tag_customer}-${var.tag_product}-${var.tag_environment}-tf-"
  image_id        = "${var.ami_id}"
  instance_type   = "${var.instance_type}"
  key_name        = "${var.key_name}"
  security_groups = ["${aws_security_group.sg_instance.id}"]
  user_data       = "${module.bootstrap.user_data}"
}

resource "aws_autoscaling_group" "main_asg" {
  # We want this to explicitly depend on the launch config above
  depends_on            = ["aws_launch_configuration.launch_config", "aws_elb.elb"]
  name                  = "${var.tag_customer}-${var.tag_product}-${var.tag_environment}-tf"

  # The chosen availability zones *must* match the AZs the VPC subnets are tied to.
  availability_zones    = ["${split(",", var.availability_zones)}"]
  vpc_zone_identifier   = ["${split(",", var.vpc_zone_subnets)}"]

  # Uses the ID from the launch config created above
  launch_configuration  = "${aws_launch_configuration.launch_config.id}"

  max_size              = "${var.asg_number_of_instances}"
  min_size              = "${var.asg_minimum_number_of_instances}"
  desired_capacity      = "${var.asg_number_of_instances}"

  health_check_grace_period = "${var.health_check_grace_period}"
  health_check_type         = "${var.health_check_type}"

  load_balancers        = ["${aws_elb.elb.id}"]
  termination_policies  = ["${split(",", var.termination_policy)}"]

  tag {
    key = "Name"
    value = "${var.tag_customer}-${var.tag_product}-${var.tag_environment}"
    propagate_at_launch = true
  }
  tag {
    key   = "Description"
    value = "${var.tag_description}"
    propagate_at_launch = true
  }
  tag {
    key   = "Environment"
    value = "${var.tag_environment}"
    propagate_at_launch = true
  }
  tag {
    key   = "Creator"
    value = "${var.tag_creator}"
    propagate_at_launch = true
  }
  tag {
    key   = "Customer"
    value = "${var.tag_customer}"
    propagate_at_launch = true
  }
  tag {
    key   = "Owner"
    value = "${var.tag_owner}"
    propagate_at_launch = true
  }
  tag {
    key   = "Product"
    value = "${var.tag_product}"
    propagate_at_launch = true
  }
  tag {
    key   = "Costcenter"
    value = "${var.tag_costcenter}"
    propagate_at_launch = true
  }
}
