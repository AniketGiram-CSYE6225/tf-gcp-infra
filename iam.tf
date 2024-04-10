resource "google_service_account" "nscc_service_account" {
  account_id                   = var.service_account_id
  display_name                 = var.service_account_displayname
  create_ignore_already_exists = true
}

resource "google_service_account" "nscc_encryption_service_account" {
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

resource "google_project_iam_binding" "vm_pubsub_publisher" {
  project = var.project_name
  role    = var.pub_sub_role

  members = [
    google_service_account.nscc_service_account.member,
  ]
}
