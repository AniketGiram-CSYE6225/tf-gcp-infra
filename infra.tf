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
      ipv4_enabled                                  = false
      private_network                               = google_compute_network.nscc_vpc.id
      enable_private_path_for_google_cloud_services = true
    }
    backup_configuration {
      enabled            = true
      binary_log_enabled = true
    }
    location_preference {
      zone = var.compute_zone
    }
  }
  encryption_key_name = google_kms_crypto_key.sql_key.id
  depends_on          = [google_compute_network.nscc_vpc, google_service_networking_connection.private_vpc_connection]
}

resource "google_compute_global_address" "private_ip_address" {
  name          = var.compute_address_name
  purpose       = var.compute_address_purpose
  address_type  = var.compute_address_type
  prefix_length = 16
  ip_version    = var.compute_address_ip_version
  network       = google_compute_network.nscc_vpc.name

}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.nscc_vpc.name
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
  depends_on              = [google_compute_global_address.private_ip_address]
  deletion_policy         = "ABANDON"
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

resource "google_dns_record_set" "a_record" {
  name         = var.domain_name
  managed_zone = var.managed_zone
  type         = var.record_type
  ttl          = var.dns_ttl
  rrdatas      = [google_compute_address.default.address]
}
