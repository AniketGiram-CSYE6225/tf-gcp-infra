resource "google_cloudfunctions2_function" "default" {
  project  = var.project_name
  name     = var.cloud_function_name
  location = var.region
  build_config {
    runtime     = var.runtime
    entry_point = var.entry_point
    source {
      repo_source {
        project_id  = var.project_name
        repo_name   = var.repo_name
        branch_name = var.branch_name
      }
    }
  }

  service_config {
    max_instance_count = var.cloud_fn_max_count
    available_memory   = var.cloud_fn_available_memory
    timeout_seconds    = var.cloud_fn_timeout_setting
    environment_variables = {
      MAILGUN_API_KEY            = var.mailgub_api_key
      EMAIL_LINK_EXPIRY_DURATION = var.email_link_expiry_duration
      DB_DIALECT                 = "mysql"
      DB_NAME                    = "${google_sql_database.nscc-database.name}"
      DB_USERNAME                = "${google_sql_user.nscc-db-users.name}"
      DB_PASSWORD                = "${random_password.nscc-db-password.result}"
      DB_HOST                    = "${google_sql_database_instance.nscc-db-instance.private_ip_address}"
    }
    ingress_settings               = var.cloud_fn_ingress_setting
    service_account_email          = google_service_account.nscc_service_account.email
    vpc_connector                  = google_vpc_access_connector.vpc-connector.name
    vpc_connector_egress_settings  = var.cloud_fn_vpc_peering_egress_setting
    all_traffic_on_latest_revision = true
  }

  event_trigger {
    trigger_region = var.region
    event_type     = var.cloud_fn_event_trigger_type
    pubsub_topic   = var.pub_sub_topic_path_name
    retry_policy   = var.pub_sub_retry_policy
  }

  depends_on = [google_pubsub_topic.verifyUser, google_sql_database.nscc-database]
}


resource "google_vpc_access_connector" "vpc-connector" {
  name          = var.vpc_connector_name
  machine_type  = var.vpc_connector_machine_type
  min_instances = var.vpc_connector_min_instance_count
  max_instances = var.vpc_connector_max_instance_count
  region        = var.region
  ip_cidr_range = var.vpc_connector_ip_cidr
  network       = google_compute_network.nscc_vpc.name
}
