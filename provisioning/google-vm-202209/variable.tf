variable "project_unique_id" {}

variable "allowed_ipaddr_list" {
  type    = list(string)
  default = ["127.0.0.1/8"]
}

# <Google>
variable "gcp_default_region" {}
# variable "gcp_project_id" {}
# </Google>

variable "firewall_tags" {
  default = {
    firewall-ingress-allow-from-allowed-list = "firewall-ingress-allow-from-allowed-list"
  }
}
