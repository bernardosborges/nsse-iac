data "aws_security_group" "worker" {
  filter {
    name   = "tag:Name"
    values = [var.security_groups.worker_security_group_name]
  }
}

data "aws_security_group" "control_plane" {
  filter {
    name   = "tag:Name"
    values = [var.security_groups.control_plane_security_group_name]
  }
}
