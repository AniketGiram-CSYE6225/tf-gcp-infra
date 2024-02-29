resource "random_id" "db_name_suffix" {
  byte_length = 4
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
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
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
