# create security group for the webserver

resource "aws_security_group" "webserver_sg" {
  name        = "web server security group"
  description = "Allow tls inbound traffic"
  vpc_id      = var.vpc_id
  depends_on = [
    var.vpc_id
  ]


  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "webserver sg"
  }
}

# create security group for the appserver

resource "aws_security_group" "app_sg" {
  name        = "app server security group"
  description = "enable ssh access on port 22"
  vpc_id      = var.vpc_id
  depends_on = [
    var.vpc_id
  ]


  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "app sg"
  }
}




# create security group for the database
resource "aws_security_group" "db_sg" {
  name        = "database security group"
  description = "allow traffic only from app_sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
    cidr_blocks     = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags   = {
    Name = "database security groups"
  }
}



# create security group for the application load balancer

resource "aws_security_group" "alb_sg" {
  name        = "alb security group"
  description = "enable http access on port 80"
  vpc_id      = var.vpc_id

  ingress {
    description      = "http access"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "alb security groups"
  }
}
