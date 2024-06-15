# Define the data source for fetching the latest Amazon Linux 2 AMI
data "aws_ami" "linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  owners = ["amazon"]
}

# Define the launch template for the bastion host
resource "aws_launch_template" "ec2module_bastion" {
  name_prefix            = "ec2_web"
  image_id               = data.aws_ami.linux.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [var.webserver_security_group_id]
  user_data              = filebase64("script.sh")

  tags = {
    Name = "ec2_bastion"
  }
}

# Define the autoscaling group for the bastion host
resource "aws_autoscaling_group" "ec2_bastion" {
  name                = "as_bastion"
  vpc_zone_identifier = [var.public_subnet_az1_id, var.public_subnet_az2_id]
  min_size            = 1
  max_size            = 1
  desired_capacity    = 1

  launch_template {
    id      = aws_launch_template.ec2module_bastion.id
    # version = "$Latest"
  }

  # Attach CloudWatch alarms for CPU utilization
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

# Define CloudWatch alarms for bastion host CPU utilization
resource "aws_cloudwatch_metric_alarm" "bastion_cpu_alarm" {
  alarm_name          = "ec2_bastion_cpu_alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "Alarm when CPU exceeds 70% for 10 minutes"
  alarm_actions       = [] # Add SNS topic ARNs or other actions here
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.ec2_bastion.name
  }
}

# Define scaling policies for the bastion host autoscaling group
resource "aws_autoscaling_policy" "scale_up_bastion" {
  name                   = "scale_up_bastion"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300 # 5 minutes
  autoscaling_group_name = aws_autoscaling_group.ec2_bastion.name
}

resource "aws_autoscaling_policy" "scale_down_bastion" {
  name                   = "scale_down_bastion"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300 # 5 minutes
  autoscaling_group_name = aws_autoscaling_group.ec2_bastion.name
}

# Define the launch template for the application tier
resource "aws_launch_template" "ec2module_app" {
  name_prefix            = "ec2_app"
  image_id               = data.aws_ami.linux.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [var.appserver_security_group_id]
 user_data = filebase64("script_2.sh")
  tags = {
    Name = "ec2_app_tier"
  }
}

# Define the autoscaling group for the application tier
resource "aws_autoscaling_group" "as_app" {
  name                = "ec2As_app"
  vpc_zone_identifier = [var.private_app_subnet_az1_id, var.private_app_subnet_az2_id]
  min_size            = 1
  max_size            = 1
  desired_capacity    = 1

  launch_template {
    id      = aws_launch_template.ec2module_app.id
    # version = "$Latest"
  }

  # Attach CloudWatch alarms for CPU utilization
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

# Define CloudWatch alarms for application tier CPU utilization
resource "aws_cloudwatch_metric_alarm" "app_cpu_alarm" {
  alarm_name          = "ec2_app_cpu_alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Alarm when CPU exceeds 80% for 10 minutes"
  alarm_actions       = [] # Add SNS topic ARNs or other actions here
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.as_app.name
  }
}

# Define scaling policies for the application tier autoscaling group
resource "aws_autoscaling_policy" "scale_up_app" {
  name                   = "scale_up_app"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300 # 5 minutes
  autoscaling_group_name = aws_autoscaling_group.as_app.name
}

resource "aws_autoscaling_policy" "scale_down_app" {
  name                   = "scale_down_app"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300 # 5 minutes
  autoscaling_group_name = aws_autoscaling_group.as_app.name
}
