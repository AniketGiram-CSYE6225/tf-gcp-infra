resource "google_compute_address" "default" {
  name         = var.static_ip_name
  address_type = var.static_ip_address_type
  network_tier = var.compute_network_tier
  region       = var.region
}

resource "google_compute_region_backend_service" "default" {
  name                  = var.load_balancer_backend_name
  region                = var.region
  load_balancing_scheme = var.load_balancer_backend_scheme
  health_checks         = [google_compute_region_health_check.autohealing.id]
  protocol              = var.load_balancer_backend_protocol
  session_affinity      = var.load_balancer_backend_session
  timeout_sec           = var.load_balancer_backend_timeout_sec
  backend {
    group           = google_compute_region_instance_group_manager.compute_instance_group_manager.instance_group
    balancing_mode  = var.load_balancer_backend_balancing
    capacity_scaler = var.load_balancer_backend_capacity_scaler
  }
}

resource "google_compute_region_url_map" "default" {
  name            = var.google_compute_region_url_map_name
  region          = var.region
  default_service = google_compute_region_backend_service.default.id
}

resource "google_compute_region_target_https_proxy" "default" {
  name             = var.google_compute_region_target_https_proxy_name
  region           = var.region
  url_map          = google_compute_region_url_map.default.id
  ssl_certificates = [google_compute_region_ssl_certificate.default.id]
}

resource "google_compute_forwarding_rule" "default" {
  name       = var.google_compute_forwarding_rule_name
  depends_on = [google_compute_subnetwork.proxy_only]
  region     = var.region

  ip_protocol           = var.google_compute_forwarding_rule_ip_protocol
  load_balancing_scheme = var.google_compute_forwarding_load_balancing_scheme
  port_range            = var.load_balancer_front_end_port
  target                = google_compute_region_target_https_proxy.default.id
  network               = google_compute_network.nscc_vpc.id
  ip_address            = google_compute_address.default.id
  network_tier          = var.google_compute_forwarding_network_tier
}

resource "google_compute_region_ssl_certificate" "default" {
  region      = var.region
  name        = var.ssl_cert_name
  private_key = file(var.ssl_cert_key_path)
  certificate = file(var.ssl_cert_cert_path)

  lifecycle {
    create_before_destroy = true
  }
}
