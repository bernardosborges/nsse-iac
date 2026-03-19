module "ec2_worker_instances" {
  source = "./modules/ec2"

  instance_profile_name  = aws_iam_instance_profile.instance_profile.name
  launch_template        = {
    name                                 = var.worker_launch_template.name
    disable_api_stop                     = var.worker_launch_template.disable_api_stop
    disable_api_termination              = var.worker_launch_template.disable_api_termination
    instance_type                        = var.worker_launch_template.instance_type
    instance_initiated_shutdown_behavior = var.worker_launch_template.instance_initiated_shutdown_behavior
    key_name                             = aws_key_pair.this.key_name
    image_id                             = data.aws_ami.this.image_id
    vpc_security_group_ids               = [aws_security_group.allow_ssh.id]
  }
  auto_scaling_group     = {
    name                                 = var.worker_auto_scaling_group.name
    max_size                             = var.worker_auto_scaling_group.max_size
    min_size                             = var.worker_auto_scaling_group.min_size
    desired_capacity                     = var.worker_auto_scaling_group.desired_capacity
    health_check_grace_period            = var.worker_auto_scaling_group.health_check_grace_period
    health_check_type                    = var.worker_auto_scaling_group.health_check_type
    vpc_zone_identifier                  = data.aws_subnets.private_subnets.ids
  }
  tags                   = var.tags
}