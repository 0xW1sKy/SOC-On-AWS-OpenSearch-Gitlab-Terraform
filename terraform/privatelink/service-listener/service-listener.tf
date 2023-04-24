variable "service_listener_config" {
  # type = object({
  #   aws_vpc_id              = string
  #   network_lb_id           = string
  #   loadbalancer_target_ips = list(string)
  #   service_port            = number
  #   protocol                = string
  #   target_type             = string
  # })
}

locals {
  loadbalancer_target_ips = toset(var.service_listener_config.loadbalancer_target_ips)
}


data "aws_vpc" "imported" {
  id = var.service_listener_config.aws_vpc_id
}
resource "aws_lb_target_group" "targetgroup" {
  port        = var.service_listener_config.service_port
  protocol    = var.service_listener_config.protocol
  vpc_id      = data.aws_vpc.imported.id
  target_type = var.service_listener_config.target_type
  health_check {
    interval = 30
    # timeout             = 10  # can't be set when protocol is tcp.
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}



data "aws_lb" "imported" {
  arn = var.service_listener_config.network_lb_id
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = data.aws_lb.imported.id
  port              = aws_lb_target_group.targetgroup.port
  protocol          = aws_lb_target_group.targetgroup.protocol
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.targetgroup.arn
  }
}


resource "aws_lb_target_group_attachment" "instance" {
  for_each          = local.loadbalancer_target_ips
  target_group_arn  = aws_lb_target_group.targetgroup.arn
  target_id         = each.key
  port              = aws_lb_target_group.targetgroup.port
  availability_zone = "all"
}

