resource "google_compute_address" "default" {
  name         = "webapp-ip"
  address_type = "EXTERNAL"
  network_tier = "STANDARD"
  region       = var.region
}

resource "google_compute_region_backend_service" "default" {
  name                  = "l7-xlb-backend-service"
  region                = var.region
  load_balancing_scheme = "EXTERNAL_MANAGED"
  health_checks         = [google_compute_region_health_check.autohealing.id]
  protocol              = "HTTP"
  session_affinity      = "NONE"
  timeout_sec           = 30
  backend {
    group           = google_compute_region_instance_group_manager.compute_instance_group_manager.instance_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }
}

resource "google_compute_region_url_map" "default" {
  name            = "regional-l7-xlb-map"
  region          = var.region
  default_service = google_compute_region_backend_service.default.id
}

resource "google_compute_region_target_http_proxy" "default" {
  name    = "l7-xlb-proxy"
  region  = var.region
  url_map = google_compute_region_url_map.default.id
}

resource "google_compute_forwarding_rule" "default" {
  name       = "l7-xlb-forwarding-rule"
  depends_on = [google_compute_subnetwork.proxy_only]
  region     = var.region

  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = "8080"
  target                = google_compute_region_target_http_proxy.default.id
  network               = google_compute_network.nscc_vpc.id
  ip_address            = google_compute_address.default.id
  network_tier          = "STANDARD"
}
