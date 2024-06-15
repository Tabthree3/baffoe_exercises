output "app_asg" {
  value = aws_autoscaling_group.as_app
}

output "web_asg" {
  value = aws_autoscaling_group.ec2_bastion
}