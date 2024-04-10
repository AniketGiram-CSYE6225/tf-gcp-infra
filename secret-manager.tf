resource "google_secret_manager_secret" "webapp_secret" {
  secret_id = var.google_secret_manager_secret_name
  
  replication {
    user_managed {
      replicas {
        location = var.region
        customer_managed_encryption {
          kms_key_name = google_kms_crypto_key.secret_manager_key.id
        }
      }
    }
  }
}

resource "google_secret_manager_secret_version" "webapp_secret_version" {
  secret = google_secret_manager_secret.webapp_secret.id

  secret_data = jsonencode({
    region       = var.region,
    tag          = google_compute_subnetwork.webapp.name,
    machine_type = var.compute_machine_type
    network_interface = {
      network    = google_compute_network.nscc_vpc.name
      subnetwork = google_compute_subnetwork.webapp.name
    }
    service_account         = google_service_account.nscc_service_account.email
    scope                   = join(",", var.service_account_scopes)
    maintenance_policy      = var.instance-template-maintenance-policy-git
    image_project           = var.project_name
    boot_disk_type          = var.instance-template-boot-disk-type-git
    kms_key                 = google_kms_crypto_key.compute_key.id
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
  })
  deletion_policy = var.instance-template-deletion-policy-git
}
