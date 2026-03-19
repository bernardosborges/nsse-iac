resource "aws_launch_template" "this" {
  name                                 = var.launch_template.name
  disable_api_stop                     = var.launch_template.disable_api_stop
  disable_api_termination              = var.launch_template.disable_api_termination
  instance_type                        = var.launch_template.instance_type
  key_name                             = var.key_name
#  key_name                             = aws_key_pair.this.key_name
  image_id                             = var.image_id
#  image_id                             = data.aws_ami.this.image_id
  instance_initiated_shutdown_behavior = var.launch_template.instance_initiated_shutdown_behavior
  vpc_security_group_ids               = var.vpc_security_group_ids
#  vpc_security_group_ids               = [aws_security_group.allow_ssh.id]

  block_device_mappings {
    device_name = "/dev/sdf"

    ebs {
      volume_size           = var.launch_template.ebs.volume_size
      delete_on_termination = var.launch_template.ebs.delete_on_termination
    }
  }

  iam_instance_profile {
    name = var.instance_profile_name
#    name = aws_iam_instance_profile.instance_profile.name
  }

  tag_specifications {
    resource_type = "instance"
    tags          = var.tags
  }
}