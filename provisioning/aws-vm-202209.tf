module "aws-vm-202209" {
  source              = "./aws-vm-202209"
  project_unique_id   = "${var.project_unique_id}-aws-vm-202209"
  allowed_ipaddr_list = var.allowed_ipaddr_list
  aws_default_region  = var.aws_default_region
}

output "aws-vm-202209" {
  value     = module.aws-vm-202209
  sensitive = true
}
