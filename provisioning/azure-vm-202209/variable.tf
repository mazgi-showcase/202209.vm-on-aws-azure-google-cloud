variable "project_unique_id" {}

variable "allowed_ipaddr_list" {
  type    = list(string)
  default = ["127.0.0.1/8"]
}

# <Azure>
variable "azure_default_location" {}
# </Azure>
