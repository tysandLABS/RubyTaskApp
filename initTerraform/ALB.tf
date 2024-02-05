resource "aws_lb_target_group" "blue-app" {
  name        = "blue-app"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.app_vpc.id

  health_check {
    enabled = true
    path    = "/"
  }

  depends_on = [aws_alb.ruby_app]
}

resource "aws_lb_target_group" "green-app2" {
  name        = "green-app2"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.app_vpc.id

  health_check {
    enabled = true
    path    = "/"
  }

  depends_on = [aws_alb.ruby_app]
}

resource "aws_alb" "ruby_app" {
  name               = "ruby-lb"
  internal           = false
  load_balancer_type = "application"

  subnets = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id,
  ]

  security_groups = [
    aws_security_group.http.id,
  ]

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_alb_listener" "blue_app_listener" {
  load_balancer_arn = aws_alb.ruby_app.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue-app.arn
  }
}

resource "aws_alb_listener" "green_app_listener2" {
  load_balancer_arn = aws_alb.ruby_app.arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.green-app2.arn
  }
}

output "alb_url" {
  value = "http://${aws_alb.ruby_app.dns_name}"
}
