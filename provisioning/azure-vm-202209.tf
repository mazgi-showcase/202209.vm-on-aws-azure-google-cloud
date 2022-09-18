module "azure-vm-202209" {
  source                 = "./azure-vm-202209"
  project_unique_id      = "${var.project_unique_id}-azure-vm-202209"
  allowed_ipaddr_list    = var.allowed_ipaddr_list
  azure_default_location = var.azure_default_location
}

output "azure-vm-202209" {
  value     = module.azure-vm-202209
  sensitive = true
}
