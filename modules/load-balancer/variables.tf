variable "public_subnet_az1_id" {}
variable "public_subnet_az2_id" {}
variable "vpc_id" {}
variable "webserver_security_group_id" {}
variable "app_asg" {}



variable "tg_protocol" {
  default = "HTTP"
}

variable "tg_port" {
  default = 80
}

variable "listener_protocol" {
  default = "HTTP"
}

variable "listener_port" {
  default = 80
}