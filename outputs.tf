/*
 * Module: tf_aws_sg_elb_lc_asg
 *
 * Outputs:
 *    - sg_instance_id
 *    - sg_elb_id
*     - elb_id
 *    - launch_config_id
 *    - asg_id
 */

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
