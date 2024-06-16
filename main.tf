
#create vpc

module "vpc" {
  source                       = "./modules/vpc"
  region                       = var.region
  project_name                 = var.project_name
  vpc_cidr                     = var.vpc_cidr
  public_subnet_az1_cidr       = var.public_subnet_az1_cidr
  public_subnet_az2_cidr       = var.public_subnet_az2_cidr
  private_app_subnet_az1_cidr  = var.private_app_subnet_az1_cidr
  private_app_subnet_az2_cidr  = var.private_app_subnet_az2_cidr
  private_data_subnet_az1_cidr = var.private_data_subnet_az1_cidr
  private_data_subnet_az2_cidr = var.private_data_subnet_az2_cidr
  #db_name = var.db_name
  #db_password = var.db_password
}

#create security groups

module "security-groups" {
  source = "./modules/security-groups"
  vpc_id = module.vpc.vpc_id

}

#create nat gateway

module "nat-gateway" {
  source                     = "./modules/nat-gateway"
  public_subnet_az1_id       = module.vpc.public_subnet_az1_id
  internet_gateway           = module.vpc.internet_gateway
  public_subnet_az2_id       = module.vpc.public_subnet_az2_id
  vpc_id                     = module.vpc.vpc_id
  private_app_subnet_az1_id  = module.vpc.private_app_subnet_az1_id
  private_data_subnet_az1_id = module.vpc.private_data_subnet_az1_id
  private_app_subnet_az2_id  = module.vpc.private_app_subnet_az2_id
  private_data_subnet_az2_id = module.vpc.private_data_subnet_az2_id
}


#create database

module "database" {
  source                       = "./modules/database"
  vpc_id                       = module.vpc.vpc_id
  private_data_subnet_az1_cidr = module.vpc.private_data_subnet_az1_id
  private_data_subnet_az2_cidr = module.vpc.private_data_subnet_az2_id
  db_security_group_id = module.security-groups.db_security_group_id
  db_name     = var.db_name
  db_password = var.db_password

}



#create EC2 instances

module "ec2" {
  source                      = "./modules/ec2"
  private_app_subnet_az1_id   = module.vpc.private_app_subnet_az1_id
  public_subnet_az1_id        = module.vpc.public_subnet_az1_id
  private_app_subnet_az2_id   = module.vpc.private_app_subnet_az2_id
  public_subnet_az2_id        = module.vpc.public_subnet_az2_id
  webserver_security_group_id = module.security-groups.webserver_security_group_id
  appserver_security_group_id = module.security-groups.appserver_security_group_id
  alb_tg                      = module.load-balancer.alb_tg
}

#create load balancer

module "load-balancer" {
  source                      = "./modules/load-balancer"
  vpc_id                      = module.vpc.vpc_id
  public_subnet_az1_id        = module.vpc.public_subnet_az1_id
  public_subnet_az2_id        = module.vpc.public_subnet_az2_id
  webserver_security_group_id = module.security-groups.webserver_security_group_id
  app_asg                     = module.ec2.app_asg
}
