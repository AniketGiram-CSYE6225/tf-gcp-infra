resource "random_id" "db_name_suffix" {
  byte_length = var.random_id_length
}

resource "google_sql_database_instance" "nscc-db-instance" {
  name                = "nscc-instance-${random_id.db_name_suffix.hex}"
  database_version    = var.database_version
  region              = var.region
  deletion_protection = false
  settings {
    tier                        = var.database_tier
    availability_type           = var.routing_mode
    deletion_protection_enabled = false
    disk_type                   = var.database_disk_type
    disk_size                   = var.database_disk_size
    ip_configuration {
      ipv4_enabled = false
      psc_config {
        psc_enabled               = true
        allowed_consumer_projects = [var.project_name]
      }
    }
    backup_configuration {
      enabled            = true
      binary_log_enabled = true
    }
  }
  depends_on = [google_compute_network.nscc_vpc]
}

resource "google_sql_database" "nscc-database" {
  name       = var.sql_database_name
  instance   = google_sql_database_instance.nscc-db-instance.name
  depends_on = [google_sql_database_instance.nscc-db-instance]
}

resource "random_password" "nscc-db-password" {
  length           = var.password_length
  special          = true
  override_special = var.password_special_char
}

resource "google_sql_user" "nscc-db-users" {
  name       = var.sql_user_name
  instance   = google_sql_database_instance.nscc-db-instance.name
  password   = random_password.nscc-db-password.result
  depends_on = [google_sql_database_instance.nscc-db-instance]
}

resource "google_compute_address" "default" {
  name         = "psc-compute-address-${google_sql_database_instance.nscc-db-instance.name}"
  region       = var.region
  address_type = var.compute_address_type
  subnetwork   = google_compute_subnetwork.webapp.name
  address      = var.compute_address_ip
}

resource "google_compute_forwarding_rule" "default" {
  name                  = "psc-forwarding-rule-${google_sql_database_instance.nscc-db-instance.name}"
  region                = var.region
  network               = google_compute_network.nscc_vpc.self_link
  ip_address            = google_compute_address.default.self_link
  load_balancing_scheme = ""
  target                = google_sql_database_instance.nscc-db-instance.psc_service_attachment_link
}

resource "google_dns_record_set" "a_record" {
  name         = var.domain_name
  managed_zone = var.managed_zone
  type         = var.record_type
  ttl          = var.dns_ttl
  rrdatas      = [google_compute_instance.compute_instance.network_interface[0].access_config[0].nat_ip]
}

resource "google_service_account" "nscc_service_account" {
  account_id                   = var.service_account_id
  display_name                 = var.service_account_displayname
  create_ignore_already_exists = true
}

resource "google_project_iam_binding" "logging_role_binding" {
  project = var.project_name
  role    = var.logging_role

  members = [
    google_service_account.nscc_service_account.member,
  ]
}

resource "google_project_iam_binding" "monitoring_metric_writer_role_binding" {
  project = var.project_name
  role    = var.monitoring_role

  members = [
    google_service_account.nscc_service_account.member,
  ]
}
