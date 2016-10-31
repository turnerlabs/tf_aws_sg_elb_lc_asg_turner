module "my_autoscaling_group" {
  source = "github.com/turnerlabs/tf_aws_sg_elb_lc_asg_turner"

  vpc_id = "${var.vpc_id}"

  elb_listener_lb_port = "${var.elb_listener_lb_port}"
  elb_listener_instance_port = "${var.elb_listener_instance_port}"
  elb_health_check_target = "${var.elb_health_check_target}"

  user_data = "${var.user_data_file}"
  ami_id = "${var.ami_id}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_name}"

  asg_number_of_instances = "${var.asg_number_of_instances}"
  availability_zones = "${var.availability_zones}"
  vpc_zone_subnets = "${var.vpc_zone_subnets}"
  vpc_cidr_block = "${var.vpc_cidr_block}"

  tag_name = "example"
  tag_application = "test-app"
  tag_product = "product"
  tag_customer = "${var.tag_customer}"
  tag_environment = "dev"
  tag_contact_email = "TBD"
  emrl_products = "${var.emrl_products}"
  emrl_package_size = "${var.emrl_package_size}"
}
