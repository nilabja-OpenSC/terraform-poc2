#Application load balancer for web server
resource "aws_lb" "project-load-balancer" {
  name               = "${var.ENVIRONMENT}-project-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.webservers_alb-sg.id]
#  subnets            = ["${var.vpc_public_subnet1}", "${var.vpc_public_subnet2}"]

}

# Add Target Group
resource "aws_lb_target_group" "load-balancer-target-group" {
  name     = "load-balancer-target-group"
  port     = 80
  protocol = "HTTP"
#  vpc_id   = var.vpc_id
}

# Adding HTTP listener
resource "aws_lb_listener" "webserver_listner" {
  load_balancer_arn = aws_lb.project-load-balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.load-balancer-target-group.arn
    type             = "forward"
  }
}

output "web-load_balancer_output" {
  value = aws_lb.project-load-balancer.dns_name
}