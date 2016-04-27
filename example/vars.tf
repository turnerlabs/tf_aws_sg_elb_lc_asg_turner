variable "vpc_id" {
  default = "<your vpcid>"
}

variable "vpc_cidr_block" {
}


variable "elb_listener_lb_port" {
  default = "80"
}
variable "elb_listener_instance_port" {
  default = "3000"
}
variable "elb_health_check_target" {
  default = "HTTP:3000/healthcheck"
}

variable "user_data_file" {
  default = "user-data.sh"
}
variable "ami_id" {
  default = "ami-fce3c696"
}
variable "instance_type" {
  default = "t2.small"
}
variable "key_name" {
  default = "<your ec2 keyname>"
}

variable "asg_number_of_instances" {
  default = 2
}
variable "availability_zones" {
  default = "us-east-1a,us-east-1b"
}
variable "vpc_zone_subnets" {
  default = "<subnet in us-east-1a>,<subnet in us-east-1b"
}
