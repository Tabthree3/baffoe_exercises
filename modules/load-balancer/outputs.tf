output "elb" {
  value = aws_lb.module_lb.id
}

output "alb_tg" {
  value = aws_lb_target_group.module_tg.arn
}

output "alb_dns" {
  value = aws_lb.module_lb.dns_name
}