resource "random_id" "random_key_for_disk_name" {
  byte_length = var.random_id_length
}

resource "google_compute_region_instance_template" "compute_instance_template" {
  name         = "${var.compute_instance_template_name}-${random_id.random_key_for_disk_name.hex}"
  tags         = [google_compute_subnetwork.webapp.name]
  region       = var.region
  machine_type = var.compute_machine_type


  scheduling {
    automatic_restart   = var.compute_instance_template_scheduling_auto_start
    on_host_maintenance = var.compute_instance_template_scheduling_on_host_maintenance
  }

  disk {
    disk_name    = "${var.compute_instance_template_disk_name}-${random_id.random_key_for_disk_name.hex}"
    source_image = var.compute_image
    auto_delete  = true
    boot         = true
    disk_encryption_key {
      kms_key_self_link = google_kms_crypto_key.compute_key.id
    }
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
  name               = var.compute_instance_group_manager_name
  base_instance_name = var.compute_instance_group_manager_base_instance_name
  region             = var.region
  auto_healing_policies {
    health_check      = google_compute_region_health_check.autohealing.id
    initial_delay_sec = var.compute_instance_group_manager_init_delay_sec
  }
  named_port {
    name = var.compute_instance_group_manager_named_port_name
    port = var.compute_instance_group_manager_named_port_port
  }
  target_size = var.compute_instance_group_manager_target_size
  version {
    instance_template = google_compute_region_instance_template.compute_instance_template.id
  }
}

resource "google_compute_region_health_check" "autohealing" {
  name                = var.load_balancer_health_check_name
  check_interval_sec  = var.load_balancer_health_check_check_interval_sec
  timeout_sec         = var.load_balancer_health_check_timeout_sec
  healthy_threshold   = var.load_balancer_health_check_healthy_threshold
  unhealthy_threshold = var.load_balancer_health_check_unhealthy_threshold
  region              = var.region
  http_health_check {
    request_path = var.load_balancer_health_check_request_path
    port         = var.compute_instance_group_manager_named_port_port
  }
}

resource "google_compute_region_autoscaler" "compute_auto_scaler" {
  name   = var.compute_auto_scaler_name
  region = var.region
  target = google_compute_region_instance_group_manager.compute_instance_group_manager.id

  autoscaling_policy {
    max_replicas    = var.compute_auto_scaler_autoscaling_policy_max_replicas
    min_replicas    = var.compute_auto_scaler_autoscaling_policy_min_replicas
    cooldown_period = var.compute_auto_scaler_autoscaling_policy_cooldown_period

    cpu_utilization {
      target = var.compute_auto_scaler_autoscaling_policy_cpu_target
    }
  }
}
