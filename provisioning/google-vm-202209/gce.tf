resource "google_compute_address" "vm-1" {
  name = "vm-1"
}

# You can list Ubuntu images by the following command.
# gcloud compute images list --project=ubuntu-os-cloud --no-standard-images --format="value(NAME)"
# See also:
#   - https://cloud.google.com/sdk/gcloud/reference/compute/images/list
data "google_compute_image" "ubuntu" {
  family  = "ubuntu-2204-lts"
  project = "ubuntu-os-cloud"
}

resource "google_compute_instance" "vm-1" {
  name = "vm-1"
  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu.id
    }
  }
  machine_type = "e2-micro"
  metadata = {
    "block-project-ssh-keys" = true
    "ssh-keys" = format("ubuntu:%s",
      file("~/.ssh/id_rsa.pub")
    )
  }
  network_interface {
    access_config {
      nat_ip = google_compute_address.vm-1.address
    }
    subnetwork = google_compute_subnetwork.vms.id
  }
  tags = [
    var.firewall_tags.firewall-ingress-allow-from-allowed-list
  ]
}
