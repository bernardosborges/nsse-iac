module "ec2_worker_instances" {
  source = "./modules/ec2"

  vpc_zone_identifier    = data.aws_subnets.private_subnets.ids
  key_name               = aws_key_pair.this.key_name
  image_id               = data.aws_ami.this.image_id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  instance_profile_name  = aws_iam_instance_profile.instance_profile.name
  launch_template        = var.worker_launch_template
  auto_scaling_group     = var.worker_auto_scaling_group
  tags                   = var.tags
}