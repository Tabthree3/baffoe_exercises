#loadbalancer/main.tf

# Create Load balancer
resource "aws_lb" "module_lb" {
  name               = "module-loadbalancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.webserver_security_group_id]
  subnets            = [var.public_subnet_az1_id, var.public_subnet_az2_id]

  depends_on = [
    var.app_asg
  ]
}

resource "aws_lb_target_group" "module_tg" {
  name     = "alb-module-target-group"
  protocol = var.tg_protocol
  port     = var.tg_port
  vpc_id   = var.vpc_id
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }
}

resource "aws_lb_listener" "KP21_lb_listener" {
  load_balancer_arn = aws_lb.module_lb.arn
  port              = var.listener_port
  protocol          = var.listener_protocol
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.module_tg.arn
  }
}
