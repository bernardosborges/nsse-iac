resource "aws_docdb_subnet_group" "this" {
  name       = var.documentdb_cluster.subnet_group_name
  subnet_ids = data.aws_subnets.private_subnets.ids

  tags = merge(var.tags, {
    Name = var.documentdb_cluster.subnet_group_name
  })
}