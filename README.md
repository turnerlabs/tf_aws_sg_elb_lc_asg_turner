tf_aws_elb_sg_lc_asg_turner
==============

This is an expanded upon version of https://github.com/turnerlabs/tf_aws_sg_elb_lc_asg
which was originally taken from https://github.com/terraform-community-modules/tf_aws_asg_elb

This is a Terraform module for creating 2 Security Groups(ELB and Instance), an ELB, a Launch Configuration, and an Auto-Scaling Group.
This module makes the following assumptions:
* You have a VPC that you want your instances to run in
* You can fully bootstrap your instances using an AMI + user_data
* *You want to associate the ASG with an ELB*
* You're instances behind the ELB will be in a VPC
* You're using a Security Group for the ELB and a Security Group for all instances in the ASG
* You're using the minimal tagging strategy required
* You have jq and the aws cli installed on you machine


You need to run this command before getting started to set the CidrBlock environment variable for the VPC.  We need this to tighten ELB traffic through to our instances:

export TF_VAR_vpc_cidr_block=`aws ec2 describe-vpcs --vpc-ids vpc-<id> | jq --raw-output '.Vpcs[0].CidrBlock'`


Input Variables
---------------

 Security Group

- `sg_elb_name` - The name used for the security group applied to the load balancer

- `sg_instance_name` - The name used for the security group applied to all the provisioned instances

- `vpc_id` - The VPC id that all the infrastructure is applied to


 ELB

- `elb_name` - The name used for the load balancer.

- `elb_listener_lb_port` - The port the ELB will listen to incoming traffic on.

- `elb_listener_instance_port` - The port the ELB will forward traffic to.

- `elb_health_check_healthy_threshold` - The number of checks before the instance is declared healthy.  `The default is 10.`

- `elb_health_check_unhealthy_threshold` - The number of checks before the instance is declared unhealthy.  `The default is 2.`

- `elb_health_check_timeout` - The length of time before the check times out.  `The default is 5.`

- `elb_health_check_target` - The target of the heath check. `ex. HTTP:80/healthcheck`

- `elb_health_check_interval` - The interval between health checks. `The default is 30.`

- `elb_internal_bool` - If the ELB is going to be internal or not. `The default is true.`


 Launch Configuration

- `lc_name` - The launch configuration name.

- `ami_id` - The AMI to use with the launch configuration.

- `instance_type` - The instance type.  `ex. t2.small, m1.medium`

- `key_name` - The SSH key name (uploaded to EC2) instances should be populated with.

- `user_data` - The path to the user_data file for the Launch Configuration.  Terraform will include the contents of this file in the Launch Configuration.

- `associate_public_ip_address` - This allows an instance to be externally accessible. `The default is false`


 Auto Scale Groups

- `asg_name` - The Auto-Scaling group name.

- `asg_number_of_instances` - The number of instances we want in the ASG.  `This is used to populate max_size and desired_capacity.`

- `asg_minimum_number_of_instances` - The minimum number of instances
   the ASG should maintain.  `This is used to populate min_size.  You can set it to 0 if you want the ASG to do nothing when an instances fails.  The default is 1.`

- `health_check_grace_period` - Number of seconds for the health check
   time out. `The defaults is 300.``

- `health_check_type` - The health check type. Options are `ELB` and
   `EC2`. `The default is ELB.`

- `availability_zones` - A comma separated list of availability zones (AZs) for the ASG. `ex. "us-east-1a,us-east-1c"`

- `vpc_zone_instance_subnets` - A comma seperated list of VPC subnets to associate with ASG, should correspond with var.availability_zones zones.  `ex. "subnet-d2t4sad,subnet-434ladkn"`

- `vpc_zone_elb_subnets` - A comma seperated list of VPC subnets to associate with ASG, should correspond with var.availability_zones zones.  `ex. "subnet-xxx4sad,subnet-xxladkn"`

- `termination_policy` - A comma separated list of termination policies used to terminate instances.  `The default is "OldestLaunchConfiguration,OldestInstance"`

- `instance_name` - The name to be applied to the launched instances


Outputs
-------

- `launch_config_id`

- `asg_id`

- `asg_name`

Usage
-----

You can use these in your terraform template with the following steps.

1.) Adding a module resource to your template, e.g. `main.tf`

```
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
  vpc_zone_instance_subnets = "${var.vpc_zone_instance_subnets}"
  vpc_zone_elb_subnets = "${var.vpc_zone_elb_subnets}"
  vpc_cidr_block = "${var.vpc_cidr_block}"

  tag_name = "example"
  tag_application = "example-app"
  tag_product = "product"
  tag_customer = "customer"
  tag_environment = "dev"
  tag_contact_email = "dev"
}

```

2.) Setting values for the following variables, either through `terraform.tfvars` or `-var` arguments on the CLI

- aws_access_key
- aws_secret_key
- aws_region
- vpc_id
- elb_listener_lb_port
- elb_listener_instance_port
- elb_health_check_target
- user_data
- ami_id
- instance_type
- key_name
- asg_number_of_instances
- availability_zones
- vpc_zone_instance_subnets
- vpc_zone_elb_subnets
- tag_name
- tag_application
- tag_product
- tag_customer
- tag_environment
- tag_contact_email


Authors
=======

Forked from https://github.com/terraform-community-modules/tf_aws_asg_elb
Created and maintained by [Michael Smith](https://github.com/smithatlanta) (smithatlanta@gmail.com).

License
=======

Apache 2 Licensed. See LICENSE for full details.
