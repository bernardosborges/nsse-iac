resource "aws_security_group" "control_plane" {
  name        = var.ec2_resources.control_plane_security_group_name
  description = "Managing ports for control plane nodes"
  vpc_id      = data.aws_vpc.this.id

  tags = merge(var.tags, {
    Name = var.ec2_resources.control_plane_security_group_name
  })
}

# resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
#   security_group_id = aws_security_group.allow_ssh.id

#   cidr_ipv4   = var.ec2_resources.ssh_source_ip
#   from_port   = 22
#   ip_protocol = "tcp"
#   to_port     = 22
# }

resource "aws_vpc_security_group_egress_rule" "control_plane_allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.control_plane.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "control_plane_allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.control_plane.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
