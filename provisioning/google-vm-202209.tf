module "google-vm-202209" {
  source              = "./google-vm-202209"
  project_unique_id   = "${var.project_unique_id}-google-vm-202209"
  allowed_ipaddr_list = var.allowed_ipaddr_list
  gcp_default_region  = var.gcp_default_region
}

output "google-vm-202209" {
  value     = module.google-vm-202209
  sensitive = true
}
