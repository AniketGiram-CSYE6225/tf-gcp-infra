resource "google_compute_network" "nscc_vpc" {
  name                            = var.network_name
  auto_create_subnetworks         = false
  routing_mode                    = var.routing_mode
  delete_default_routes_on_create = true
}

resource "google_compute_subnetwork" "webapp" {
  name                     = var.webapp_subnet
  ip_cidr_range            = var.webapp_ip_range
  region                   = var.region
  network                  = google_compute_network.nscc_vpc.id
  depends_on               = [google_compute_network.nscc_vpc]
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "db" {
  name                     = var.db_subnet
  ip_cidr_range            = var.db_ip_range
  region                   = var.region
  network                  = google_compute_network.nscc_vpc.id
  depends_on               = [google_compute_network.nscc_vpc]
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "proxy_only" {
  name          = "proxy-only-subnet"
  ip_cidr_range = "10.129.0.0/23"
  network       = google_compute_network.nscc_vpc.id
  purpose       = "REGIONAL_MANAGED_PROXY"
  region        = var.region
  role          = "ACTIVE"
}

resource "google_compute_route" "webapp_route" {
  name             = var.route_name
  dest_range       = var.default_gateway_ip_range
  network          = google_compute_network.nscc_vpc.id
  next_hop_gateway = var.next_hop_gateway
  tags             = [google_compute_subnetwork.webapp.name]
}
