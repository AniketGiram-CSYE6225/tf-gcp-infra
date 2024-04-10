resource "random_string" "random_key" {
  length  = var.random_id_length
  special = false
}
resource "google_kms_key_ring" "keyring" {
  name     = "${var.google_kms_key_ring_name}-${random_string.random_key.id}"
  location = var.region
}

resource "google_kms_crypto_key" "compute_key" {
  name            = "${var.google_kms_crypto_compute_key_name}-${random_string.random_key.id}"
  key_ring        = google_kms_key_ring.keyring.id
  rotation_period = var.google_kms_crypto_key_rotation_period

  lifecycle {
    prevent_destroy = false
  }
}


resource "google_kms_crypto_key" "sql_key" {
  name            = "${var.google_kms_crypto_sql_key_name}-${random_string.random_key.id}"
  key_ring        = google_kms_key_ring.keyring.id
  rotation_period = var.google_kms_crypto_key_rotation_period
  purpose         = var.google_kms_crypto_key_purpose
  lifecycle {
    prevent_destroy = false
  }
}

resource "google_kms_crypto_key" "secret_manager_key" {
  name            = "${var.google_kms_crypto_secret_manager_key_name}-${random_string.random_key.id}"
  key_ring        = google_kms_key_ring.keyring.id
  rotation_period = var.google_kms_crypto_key_rotation_period
  purpose         = var.google_kms_crypto_key_purpose
  lifecycle {
    prevent_destroy = false
  }
}

resource "google_kms_crypto_key_iam_binding" "vm_iam" {
  crypto_key_id = google_kms_crypto_key.compute_key.id
  role          = var.google_kms_crypto_key_iam_binding_role

  members = [
    "serviceAccount:${google_service_account.nscc_encryption_service_account.email}",
  ]
}

resource "google_project_service_identity" "gcp_sa_cloud_sql" {
  provider = google-beta
  service  = var.google_project_service_identity_sql_service
}

resource "google_kms_crypto_key_iam_binding" "sql_iam" {
  provider      = google-beta
  crypto_key_id = google_kms_crypto_key.sql_key.id
  role          = var.google_kms_crypto_key_iam_binding_role

  members = [
    "serviceAccount:${google_project_service_identity.gcp_sa_cloud_sql.email}",
  ]
}

resource "google_project_service_identity" "gcp_si_cloud_secret_manager" {
  provider = google-beta
  service  = var.google_project_service_identity_secret_manager_service
}

resource "google_kms_crypto_key_iam_member" "kms-secret-binding" {
  crypto_key_id = google_kms_crypto_key.secret_manager_key.id
  role          = var.google_kms_crypto_key_iam_binding_role
  member        = "serviceAccount:${google_project_service_identity.gcp_si_cloud_secret_manager.email}"
}
