# --- compute/variables.tf ---

variable "webserver_security_group_id" {}
variable "public_subnet_az1_id" {}
variable "public_subnet_az2_id" {}
variable "appserver_security_group_id" {}
variable "private_app_subnet_az1_id" {}
variable "private_app_subnet_az2_id" {}
# variable "elb" {}
variable "alb_tg" {}

variable "bastion_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "app_instance_type" {
  type    = string
  default = "t2.micro"
}