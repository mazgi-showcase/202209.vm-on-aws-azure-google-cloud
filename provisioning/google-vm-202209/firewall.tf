resource "google_compute_firewall" "allow-from-allowed-list" {
  name      = "${var.project_unique_id}-allow-from-allowed-list"
  network   = google_compute_network.main.id
  direction = "INGRESS"
  allow {
    protocol = "tcp"
  }
  allow {
    protocol = "udp"
  }
  allow {
    protocol = "icmp"
  }
  source_ranges = var.allowed_ipaddr_list
  target_tags = [
    var.firewall_tags.firewall-ingress-allow-from-allowed-list
  ]
}
