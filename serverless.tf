resource "google_cloudfunctions2_function" "default" {
  project  = var.project_name
  name     = var.cloud_function_name
  location = var.region
  build_config {
    runtime     = var.runtime
    entry_point = var.entry_point
    source {
      repo_source {
        repo_name   = var.repo_name
        branch_name = var.branch_name
      }
    }
  }

  service_config {
    max_instance_count = 2
    available_memory   = "256M"
    timeout_seconds    = 60
    environment_variables = {
      MAILGUN_API_KEY = "2cfb7882f74ef13510580b26340522b4-309b0ef4-289c3c54"
      DB_DIALECT      = "mysql"
      DB_NAME         = "${google_sql_database.nscc-database.name}"
      DB_USERNAME     = "${google_sql_user.nscc-db-users.name}"
      DB_PASSWORD     = "${random_password.nscc-db-password.result}"
      DB_HOST         = "${google_compute_address.default.address}"
    }
    ingress_settings               = "ALLOW_INTERNAL_ONLY"
    service_account_email          = google_service_account.nscc_service_account.email
    vpc_connector                  = google_vpc_access_connector.vpc-connector.name
    vpc_connector_egress_settings  = "ALL_TRAFFIC"
    all_traffic_on_latest_revision = true
  }

  event_trigger {
    trigger_region = "us-east1"
    event_type     = "google.cloud.pubsub.topic.v1.messagePublished"
    pubsub_topic   = "projects/nscc-prod-2404/topics/verify_email"
    retry_policy   = "RETRY_POLICY_DO_NOT_RETRY"
  }

  depends_on = [google_pubsub_topic.verifyUser, google_compute_address.default, google_sql_database.nscc-database]
}


resource "google_vpc_access_connector" "vpc-connector" {
  name          = "vpc-connector"
  machine_type  = "f1-micro"
  min_instances = 2
  max_instances = 3
  region        = var.region
  ip_cidr_range = "10.0.0.0/28"
  network       = google_compute_network.nscc_vpc.name
}
