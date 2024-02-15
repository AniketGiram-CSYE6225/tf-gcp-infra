provider "google" {
  project = "nscc-414218"
  region  = "us-east1"
}

resource "random_id" "network_suffix" {
  byte_length = 2
}

resource "google_compute_network" "nscc_vpc" {
  name                            = "nscc-${random_id.network_suffix.hex}"
  auto_create_subnetworks         = false
  routing_mode                    = "REGIONAL"
  delete_default_routes_on_create = true
}

resource "google_compute_subnetwork" "webapp" {
  name                     = "webapp"
  ip_cidr_range            = "255.0.0.0/24"
  region                   = "us-east1"
  network                  = google_compute_network.nscc_vpc.id
  depends_on               = [google_compute_network.nscc_vpc]
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "db" {
  name                     = "db"
  ip_cidr_range            = "255.0.1.0/24"
  region                   = "us-east1"
  network                  = google_compute_network.nscc_vpc.id
  depends_on               = [google_compute_network.nscc_vpc]
  private_ip_google_access = true
}

resource "google_compute_route" "webapp_route" {
  name             = "webapp-route"
  dest_range       = "0.0.0.0/0"
  network          = google_compute_network.nscc_vpc.id
  next_hop_gateway = "default-internet-gateway"
  tags             = ["webapp"]
}
