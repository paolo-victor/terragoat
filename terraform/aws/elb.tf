# Create a new load balancer
resource "aws_elb" "weblb" {
  # Drata: Configure [aws_elb.internal] to true to disable public access. It is recommended to explicitly allow access to trusted users or IPs. Exclude this finding if your business use-case requires ELB V1 to be publicly available
  # Drata: Configure [aws_elb.access_logs.enabled] to ensure that security-relevant events are logged to detect malicious activity
  name = "weblb-terraform-elb"

  listener {
    instance_port     = 8000
    instance_protocol = "HTTPS"
    lb_port           = 80
    lb_protocol       = "HTTPS"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8000/"
    interval            = 30
  }

  subnets                     = [aws_subnet.web_subnet.id]
  # Drata: Configure [aws_elb.subnets] to improve infrastructure availability and resilience. Define at least 2 subnets or availability zones on your load balancer to enable zone redundancy
  security_groups             = [aws_security_group.web-node.id]
  instances                   = [aws_instance.web_host.id]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = merge({
    Name = "foobar-terraform-elb"
    }, {
    git_commit           = "d68d2897add9bc2203a5ed0632a5cdd8ff8cefb0"
    git_file             = "terraform/aws/elb.tf"
    git_last_modified_at = "2020-06-16 14:46:24"
    git_last_modified_by = "nimrodkor@gmail.com"
    git_modifiers        = "nimrodkor"
    git_org              = "bridgecrewio"
    git_repo             = "terragoat"
    yor_trace            = "b4a83ce9-9a45-43b4-b6d9-1783c282f702"
  })
}