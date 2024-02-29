resource "google_compute_firewall" "compute_firewall" {
  name          = var.firewall_name
  network       = google_compute_network.nscc_vpc.name
  source_ranges = [var.default_gateway_ip_range]
  allow {
    protocol = var.firewall_protocol_tcp
    ports    = var.firewall_allowed_ports
  }
  target_tags = [google_compute_subnetwork.webapp.name]
  depends_on  = [google_compute_network.nscc_vpc, google_compute_subnetwork.webapp]
}
