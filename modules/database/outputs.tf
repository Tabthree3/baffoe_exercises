output "db_subnet_group_id" {
    value = aws_db_subnet_group.db_subnet.id
}

output "db_instance_id" {
    value = aws_db_instance.RDS_instance.id
}


// ./modules/database/variables.tf
variable "db_name" {
  description = "The name of the database"
  type        = string
}

variable "db_password" {
  description = "The password for the database"
  type        = string
  sensitive   = true
}
