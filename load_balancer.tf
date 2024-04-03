resource "google_compute_address" "default" {
  name         = "webapp-ip"
  address_type = "EXTERNAL"
  network_tier = "STANDARD"
  region       = var.region
}
