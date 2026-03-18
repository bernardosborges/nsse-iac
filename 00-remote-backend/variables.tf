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
        Project     = "nsse"
        Environment = "Production"
    }
}

variable "remote_backend" {
    type = object({
        bucket = string
    })

    default = {
        bucket = "bsb-nsse-dev-tf-state"
    }
}