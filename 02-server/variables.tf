variable "region" {
  type    = string
  default = "us-east-1"
}

variable "assume_role" {
  type = object({
    role_arn    = string
    external_id = string
  })

  default = {
    role_arn    = "arn:aws:iam::583933848805:role/terraform-role"
    external_id = "38fcec02-aedd-4633-9cca-1972705927b3"
  }
}

variable "tags" {
  type = map(string)
  default = {
    Environment = "production"
    Project     = "nsse"
  }
}

variable "vpc" {
  type = object({
    name = string
  })

  default = {
    name = "nsse-vpc"
  }
}

variable "ec2_resources" {
  type = object({
    key_pair_name                     = string
    instance_profile                  = string
    instance_role                     = string
    control_plane_security_group_name = string
    worker_security_group_name        = string
    ssh_source_ip                     = string
  })

  default = {
    key_pair_name                     = "nsse-production-key-pair"
    instance_role                     = "nsse-production-instance-role"
    instance_profile                  = "nsse-production-instance-profile"
    control_plane_security_group_name = "nsse-production-control-plane-sg"
    worker_security_group_name        = "nsse-production-worker-sg"
    ssh_source_ip                     = "177.22.167.124/32"
  }
}

variable "control_plane_launch_template" {
  type = object({
    name                                 = string
    disable_api_stop                     = bool
    disable_api_termination              = bool
    instance_type                        = string
    instance_initiated_shutdown_behavior = string
    user_data                            = string
    ebs = object({
      volume_size           = number
      delete_on_termination = bool
    })

  })

  default = {
    name                                 = "nsse-production-debian-control-plane-lt"
    disable_api_stop                     = true
    disable_api_termination              = true
    instance_type                        = "t3.micro"
    instance_initiated_shutdown_behavior = "terminate"
    user_data                            = "./cli/control-plane-user-data.sh"
    ebs = {
      volume_size           = 20
      delete_on_termination = false # false in production
    }
  }
}

variable "control_plane_auto_scaling_group" {
  type = object({
    name                      = string
    max_size                  = number
    min_size                  = number
    desired_capacity          = number
    health_check_grace_period = number
    health_check_type         = string
    instance_tags = object({
      Name = string
    })
    instance_maintenance_policy = object({
      min_healthy_percentage = number
      max_healthy_percentage = number
    })
  })

  default = {
    name                      = "nsse-production-control-plane-asg"
    max_size                  = 1
    min_size                  = 1
    desired_capacity          = 1
    health_check_grace_period = 180
    health_check_type         = "EC2"
    instance_tags = {
      Name = "nsse-production-control-plane"
    }
    instance_maintenance_policy = {
      min_healthy_percentage = 100
      max_healthy_percentage = 110
    }
  }
}

variable "worker_launch_template" {
  type = object({
    name                                 = string
    disable_api_stop                     = bool
    disable_api_termination              = bool
    instance_type                        = string
    instance_initiated_shutdown_behavior = string
    user_data                            = string
    ebs = object({
      volume_size           = number
      delete_on_termination = bool
    })

  })

  default = {
    name                                 = "nsse-production-debian-worker-lt"
    disable_api_stop                     = true
    disable_api_termination              = true
    instance_type                        = "t3.micro"
    instance_initiated_shutdown_behavior = "terminate"
    user_data                            = "./cli/worker-user-data.sh"
    ebs = {
      volume_size           = 20
      delete_on_termination = false # false in production
    }
  }
}

variable "worker_auto_scaling_group" {
  type = object({
    name                      = string
    max_size                  = number
    min_size                  = number
    desired_capacity          = number
    health_check_grace_period = number
    health_check_type         = string
    instance_tags = object({
      Name = string
    })
    instance_maintenance_policy = object({
      min_healthy_percentage = number
      max_healthy_percentage = number
    })
  })

  default = {
    name                      = "nsse-production-worker-asg"
    max_size                  = 1
    min_size                  = 1
    desired_capacity          = 1
    health_check_grace_period = 180
    health_check_type         = "EC2"
    instance_tags = {
      Name = "nsse-production-worker"
    }
    instance_maintenance_policy = {
      min_healthy_percentage = 100
      max_healthy_percentage = 110
    }
  }
}

variable "debian_patch_baseline" {
  type = object({
    name                                 = string
    description                          = string
    approved_patches_enable_non_security = bool
    operating_system                     = string
    approval_rules = list(object({
      approve_after_days = number
      compliance_level   = string
      patch_filter = object({
        product  = list(string)
        section  = list(string)
        priority = list(string)
      })
    }))
  })

  default = {
    name                                 = "DebianProductionPatchBaseline"
    description                          = "Custom Patch Baseline for Debian Production Servers"
    approved_patches_enable_non_security = false
    operating_system                     = "DEBIAN"
    approval_rules = [
      {
        approve_after_days = 0
        compliance_level   = "CRITICAL"
        patch_filter = {
          product  = ["Debian12"]
          section  = ["*"]
          priority = ["Required", "Important"]
        }
      },
      {
        approve_after_days = 0
        compliance_level   = "INFORMATIONAL"
        patch_filter = {
          product  = ["Debian12"]
          section  = ["*"]
          priority = ["Standard"]
        }
      }
    ]
  }
}

variable "patch_group" {
  type    = string
  default = "Production"
}
