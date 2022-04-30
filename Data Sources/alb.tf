#Application load balancer for web server
resource "aws_lb" "project-load-balancer" {
  name               = "${var.ENVIRONMENT}-project-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.webservers_alb-sg.id]
  subnets            = ["${aws_subnet.test_vpc_public_subnet_1.id}", "${aws_subnet.test_vpc_public_subnet_2.id}"]

}

# Add Target Group
resource "aws_lb_target_group" "load-balancer-target-group" {
  name     = "load-balancer-target-group"
  target_type = "alb"
  port     = 80
  protocol = "TCP"
  vpc_id   = aws_vpc.test_vpc.id

  health_check {
    path = "/"
    port = 80
    #protocol = "TCP"
    healthy_threshold = 6
    unhealthy_threshold = 2
    timeout = 2
    interval = 5
    matcher = "200"  # has to be HTTP 200 or fails
  }
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