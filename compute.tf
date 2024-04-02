resource "google_compute_instance" "compute_instance" {
  name = var.compute_instance_name
  boot_disk {
    initialize_params {
      image = var.compute_image
      type  = var.compute_disk_type
      size  = var.compute_disk_size
    }
  }
  tags = [google_compute_subnetwork.webapp.name]
  service_account {
    email  = google_service_account.nscc_service_account.email
    scopes = var.service_account_scopes
  }
  allow_stopping_for_update = true
  machine_type              = var.compute_machine_type
  zone                      = var.compute_zone
  network_interface {
    network    = google_compute_network.nscc_vpc.name
    subnetwork = google_compute_subnetwork.webapp.name
    access_config {
      network_tier = var.compute_network_tier
    }
  }

  metadata_startup_script = <<-EOT
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
  EOT
  depends_on              = [google_compute_network.nscc_vpc, google_compute_subnetwork.webapp, google_service_account.nscc_service_account]
}
