resource "aws_security_group" "rds" {
  name        = var.security_groups.rds_security_group_name
  description = "Managing ports for RDS"
  vpc_id      = data.aws_vpc.this.id

  tags = merge(var.tags, {
    Name = var.security_groups.rds_security_group_name
  })
}

resource "aws_vpc_security_group_ingress_rule" "control_plane_to_rds_allow_all_traffic_ipv4" {
  security_group_id            = aws_security_group.rds.id
  referenced_security_group_id = data.aws_security_group.control_plane.id
  ip_protocol                  = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "worker_to_rds_allow_all_traffic_ipv4" {
  security_group_id            = aws_security_group.rds.id
  referenced_security_group_id = data.aws_security_group.worker.id
  ip_protocol                  = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "rds_to_rds_allow_all_traffic_ipv4" {
  security_group_id            = aws_security_group.rds.id
  referenced_security_group_id = aws_security_group.rds.id
  ip_protocol                  = "-1"
}

resource "aws_vpc_security_group_egress_rule" "rds_allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.rds.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "rds_allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.rds.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
