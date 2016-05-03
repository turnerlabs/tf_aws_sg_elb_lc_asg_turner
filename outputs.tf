/*
 * Module: tf_aws_sg_elb_lc_asg
 *
 * Outputs:
 *    - elb_id
 *    - elb_name
 *    - launch_config_id
 *    - asg_id
 *    - asg_name
 */

# Output the ID of the ELB
output "elb_name" {
    value = "${aws_elb.elb.name}"
}

# Output the Name of the ELB
output "elb_name" {
    value = "${aws_elb.elb.id}"
}

# Output the ID of the Launch Config
output "launch_config_id" {
    value = "${aws_launch_configuration.launch_config.id}"
}

# Output the ID of the Auto Scale Group
output "asg_id" {
    value = "${aws_autoscaling_group.main_asg.id}"
}

# Output the Name of the Auto Scale Group
output "asg_name" {
    value = "${aws_autoscaling_group.main_asg.name}"
}
