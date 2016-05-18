/*
 * Module: tf_aws_sg_elb_lc_asg
*/


#
# Bootstrap Variables
#

variable "emrl_products" {
  description = "Emeril Products"
}
variable "emrl_package_size" {
  description = "Emeril Asset Tags"
}

#
# Security Group Variables
#

variable "vpc_id" {
  description = "The VPC id that all the infrastructure is applied to"
}


variable "vpc_cidr_block" {
  description = "The VPC CIDR Block"
}
#
# ELB Variables
#

variable "elb_listener_lb_port" {
  description = "The port the ELB will listen to incoming traffic on"
}
variable "elb_listener_instance_port" {
  description = "The port the elb will forward traffic to"
}
variable "elb_health_check_healthy_threshold" {
  description = "The number of checks before the instance is declared healthy"
  default = "2"
}
variable "elb_health_check_unhealthy_threshold" {
  description = "The number of checks before the instance is declared unhealthy"
  default = "2"
}
variable "elb_health_check_timeout" {
  description = "The length of time before the check times out"
  default = "3"
}
variable "elb_health_check_target" {
  description = "The target of the heath check. usually something like HTTP:<instance_port>/healthcheck"
}
variable "elb_health_check_interval" {
  description = "The interval between health checks"
  default = "30"
}
variable "elb_internal_bool" {
  description = "If the ELB is going to be internal or not"
  default = "true"
}

#
# Launch Configuration Variables
#
variable "ami_id" {
  description = "The AMI to use with the launch configuration"
}
variable "instance_type" {
  description = "The instance type.  ex. t2.small, m1.medium, etc."
}
variable "key_name" {
  description = "The SSH public key name (in EC2 key-pairs) to be injected into instances"
}
variable "user_data" {
  description = "The path to a file with the user_data for the instances"
}
variable "associate_public_ip_address" {
  description = "This allows an instance to be externally accessible"
  default = false
}

#
# Auto-Scaling Group
#
/* We use this to populate the following ASG settings
 * - max_size
 * - desired_capacity
 */
variable "asg_number_of_instances" {
  description = "The number of instances we want in the ASG"
}

/*
 * Can be set to 0 if you never want the ASG to replace failed instances
 */
variable "asg_minimum_number_of_instances" {
  description = "The minimum number of instances the ASG should maintain"
  default = 1
}
variable "health_check_grace_period" {
  description = "Number of seconds for a health check to time out"
  default = 300
}
/*
 * Types available are:
 *   - ELB
 *   - EC2
 *
 *   @see-also: http://docs.aws.amazon.com/cli/latest/reference/autoscaling/create-auto-scaling-group.html#options
 */
variable "health_check_type" {
  description = "The health check used by the ASG to determine health"
  default = "EC2"
}

/*
 * A string list of AZs, ex:
 * "us-east-1a,us-east-1c,us-east-1e"
 */
variable "availability_zones" {
  description = "A comma seperated list string of AZs the ASG will be associated with"
}

/*
 * A string list of VPC subnet IDs for the instances, ex:
 * "subnet-d2t4sad,subnet-434ladkn"
 */
variable "vpc_zone_instance_subnets" {
  description = "A comma seperated list string of VPC subnets to associate with ASG, should correspond with var.availability_zones zones"
}

/*
 * A string list of VPC subnet IDs for the elbs, ex:
 * "subnet-x2t4sad,subnet-x34ladkn"
 *
 * These subnets need to be in the same AZs as the ones chosen for the instances, or else the ELBs will not be able to communicate with 
 * the instances themselves.
 */
variable "vpc_zone_elbs_subnets" {
  description = "A comma seperated list string of VPC subnets to associate with ASG, should correspond with var.availability_zones zones"
}

/*
 * A string list of termination policiess, ex:
 * "OldestLaunchConfiguration,OldestInstance"
 */
variable "termination_policy" {
  description = "A comma separated list of termination policy(ies) used to terminate instances"
  default = "OldestInstance"
}

#
# Tagging across all resources
#

variable "tag_name" {
  description = ""
}
variable "tag_description" {
  description = ""
}
variable "tag_creator" {
  description = ""
}
variable "tag_product" {
  description = ""
}
variable "tag_customer" {
  description = ""
}
variable "tag_team" {
  description = ""
}
variable "tag_environment" {
  description = ""
}
variable "tag_billing" {
  description = ""
}
