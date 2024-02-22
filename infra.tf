provider "google" {
  project = var.project_name
  region  = var.region
}

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

resource "google_compute_route" "webapp_route" {
  name             = var.route_name
  dest_range       = var.default_gateway_ip_range
  network          = google_compute_network.nscc_vpc.id
  next_hop_gateway = var.next_hop_gateway
  tags             = [google_compute_subnetwork.webapp.name]
}


resource "google_compute_instance" "compute_instance" {
  name = var.compute_instance_name
  boot_disk {
    initialize_params {
      image = var.compute_image
      type  = var.compute_disk_type
      size  = var.compute_disk_size
    }
  }
  tags         = [google_compute_subnetwork.webapp.name]
  machine_type = var.compute_machine_type
  zone         = var.compute_zone
  network_interface {
    network    = google_compute_network.nscc_vpc.name
    subnetwork = google_compute_subnetwork.webapp.name
    access_config {
      network_tier = var.compute_network_tier
    }
  }
}

resource "google_compute_firewall" "compute_firewall" {
  name          = var.firewall_name
  network       = google_compute_network.nscc_vpc.name
  source_ranges = [var.default_gateway_ip_range]
  allow {
    protocol = var.firewall_protocol_tcp
    ports    = var.firewall_allowed_ports
  }
}
