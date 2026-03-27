resource "aws_security_group" "documentdb" {
  name        = var.security_groups.documentdb_security_group_name
  description = "Managing ports for DocumentDB"
  vpc_id      = data.aws_vpc.this.id

  tags = merge(var.tags, {
    Name = var.security_groups.documentdb_security_group_name
  })
}

resource "aws_vpc_security_group_ingress_rule" "control_plane_to_documentdb_allow_all_traffic_ipv4" {
  security_group_id            = aws_security_group.documentdb.id
  referenced_security_group_id = data.aws_security_group.control_plane.id
  ip_protocol                  = "tcp"
  from_port                    = 27017
  to_port                      = 27017
}

resource "aws_vpc_security_group_ingress_rule" "worker_to_documentdb_allow_all_traffic_ipv4" {
  security_group_id            = aws_security_group.documentdb.id
  referenced_security_group_id = data.aws_security_group.worker.id
  ip_protocol                  = "tcp"
  from_port                    = 27017
  to_port                      = 27017
}

resource "aws_vpc_security_group_ingress_rule" "docdb_to_docdb_allow_all_traffic_ipv4" {
  security_group_id            = aws_security_group.documentdb.id
  referenced_security_group_id = aws_security_group.documentdb.id
  ip_protocol                  = "-1"
}

resource "aws_vpc_security_group_egress_rule" "documentdb_allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.documentdb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "documentdb_allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.documentdb.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
