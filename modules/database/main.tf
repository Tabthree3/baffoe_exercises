resource "aws_db_subnet_group" "db_subnet" {
  name       = "db_subnet"
  subnet_ids = [var.private_data_subnet_az1_cidr, var.private_data_subnet_az2_cidr]
}


resource "aws_db_instance" "RDS_instance" {
  allocated_storage      = 5
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  db_subnet_group_name   = aws_db_subnet_group.db_subnet.name
  name                 = "exampledb"
vpc_security_group_ids = var.db_security_group_id
  username               = var.db_name
  password               = var.db_password
  skip_final_snapshot    = true

 tags = {
    Name = "example-database"
  }
}

