output "alb_security_group_id" {
    value = aws_security_group.alb_sg.id
}

output "db_security_group_id" {
    value = aws_security_group.db_sg.id
}

output "webserver_security_group_id" {
    value = aws_security_group.webserver_sg.id
}

output "appserver_security_group_id" {
    value = aws_security_group.app_sg.id
}

