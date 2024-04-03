resource "google_compute_region_instance_template" "compute_instance_template" {
  name         = "appserver-template"
  tags         = [google_compute_subnetwork.webapp.name]
  region       = var.region
  machine_type = var.compute_machine_type


  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  disk {
    disk_name    = "compute-instance-template-disk"
    source_image = var.compute_image
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network    = google_compute_network.nscc_vpc.name
    subnetwork = google_compute_subnetwork.webapp.name
  }

  service_account {
    email  = google_service_account.nscc_service_account.email
    scopes = var.service_account_scopes
  }

  metadata_startup_script = <<-METADATA
  #!/bin/bash
  file=/opt/webapp/.env
  if [ ! -f $file ]; then
    sudo touch $file
    sudo echo "DIALECT=mysql" >> $file
    sudo echo "DB_NAME=${google_sql_database.nscc-database.name}" >> $file
    sudo echo "DB_USERNAME=${google_sql_user.nscc-db-users.name}" >> $file
    sudo echo "DB_PASSWORD=${random_password.nscc-db-password.result}" >> $file
    sudo echo "HOST=${google_sql_database_instance.nscc-db-instance.private_ip_address}" >> $file
    sudo echo "GCP_PROJECT_ID=${var.project_name}" >> $file
    sudo echo "PUB_SUB_TOPIC_NAME=${google_pubsub_topic.verifyUser.name}" >> $file
  fi
  METADATA
}

resource "google_compute_region_instance_group_manager" "compute_instance_group_manager" {
  name               = "compute-instance-group-manager"
  base_instance_name = "webapp-manager"
  auto_healing_policies {
    health_check      = google_compute_region_health_check.autohealing.id
    initial_delay_sec = 300
  }
  named_port {
    name = "http"
    port = 8080
  }
  target_size = 2
  version {
    instance_template = google_compute_region_instance_template.compute_instance_template.id
  }
}

resource "google_compute_region_health_check" "autohealing" {
  name                = "autohealing-health-check"
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10
  region              = var.region
  http_health_check {
    request_path = "/healthz"
    port         = "8080"
  }
}

resource "google_compute_region_autoscaler" "compute_auto_scaler" {
  name   = "my-region-autoscaler"
  region = var.region
  target = google_compute_region_instance_group_manager.compute_instance_group_manager.id

  autoscaling_policy {
    max_replicas    = 5
    min_replicas    = 2
    cooldown_period = 60

    cpu_utilization {
      target = 0.5
    }
  }
}
