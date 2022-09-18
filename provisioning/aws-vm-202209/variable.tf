variable "project_unique_id" {}

variable "allowed_ipaddr_list" {
  type    = list(string)
  default = ["127.0.0.1/8"]
}

# <AWS>
variable "aws_default_region" {}
# variable "aws_access_key" {}
# variable "aws_secret_key" {}
# </AWS>
