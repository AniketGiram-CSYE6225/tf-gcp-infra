variable "project_name" {
  type = string
}

variable "region" {
  type = string
}

variable "network_name" {
  type = string
}

variable "webapp_subnet" {
  type = string
}

variable "webapp_ip_range" {
  type = string
}

variable "db_subnet" {
  type = string
}

variable "db_ip_range" {
  type = string
}

variable "route_name" {
  type = string
}

variable "default_gateway_ip_range" {
  type = string
}

variable "routing_mode" {
  type = string
}

variable "next_hop_gateway" {
  type = string
}

variable "compute_instance_name" {
  type = string
}

variable "compute_image" {
  type = string
}

variable "compute_disk_type" {
  type = string
}

variable "compute_disk_size" {
  type = number
}

variable "compute_machine_type" {
  type = string
}

variable "compute_zone" {
  type = string
}

variable "firewall_name" {
  type = string
}

variable "firewall_protocol_tcp" {
  type = string
}

variable "compute_network_tier" {
  type = string
}

variable "firewall_allowed_ports" {
  type = list(string)
}

variable "sql_database_name" {
  type = string
}

variable "sql_user_name" {
  type = string
}

variable "database_version" {
  type = string
}

variable "database_tier" {
  type = string
}

variable "database_disk_size" {
  type = number
}

variable "database_disk_type" {
  type = string
}

variable "compute_address_type" {
  type = string
}

variable "compute_address_ip" {
  type = string
}

variable "password_length" {
  type = number
}

variable "password_special_char" {
  type = string
}

variable "random_id_length" {
  type = number
}

variable "logging_role" {
  type = string
}

variable "monitoring_role" {
  type = string
}

variable "service_account_id" {
  type = string
}

variable "service_account_displayname" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "record_type" {
  type = string
}

variable "managed_zone" {
  type = string
}

variable "dns_ttl" {
  type = number
}

variable "service_account_scopes" {
  type = list(string)
}

variable "cloud_function_name" {
  type = string
}

variable "runtime" {
  type = string
}

variable "entry_point" {
  type = string
}

variable "repo_name" {
  type = string
}

variable "branch_name" {
  type = string
}

variable "compute_address_purpose" {
  type = string
}

variable "compute_address_name" {
  type = string
}

variable "compute_address_ip_version" {
  type = string
}

variable "pub_sub_role" {
  type = string
}

variable "pub_sub_schema_name" {
  type = string
}

variable "pub_sub_user_schema" {
  type = string
}

variable "pub_sub_schema_type" {
  type = string
}

variable "pub_sub_topic_name" {
  type = string
}

variable "pub_sub_schema_setting_schema" {
  type = string
}

variable "pub_sub_schema_encoding_type" {
  type = string
}

variable "pub_sub_message_retation_duration" {
  type = string
}

variable "mailgub_api_key" {
  type = string
}

variable "email_link_expiry_duration" {
  type = number
}

variable "cloud_fn_event_trigger_type" {
  type = string
}

variable "cloud_fn_ingress_setting" {
  type = string
}

variable "cloud_fn_vpc_peering_egress_setting" {
  type = string
}

variable "cloud_fn_max_count" {
  type = number
}

variable "cloud_fn_timeout_setting" {
  type = number
}

variable "cloud_fn_available_memory" {
  type = string
}

variable "pub_sub_topic_path_name" {
  type = string
}

variable "pub_sub_retry_policy" {
  type = string
}

variable "vpc_connector_name" {
  type = string
}

variable "vpc_connector_machine_type" {
  type = string
}

variable "vpc_connector_ip_cidr" {
  type = string
}

variable "vpc_connector_max_instance_count" {
  type = number
}

variable "vpc_connector_min_instance_count" {
  type = number
}

variable "health_check_firewall_name" {
  type = string
}

variable "health_check_firewall_direction" {
  type = string
}

variable "health_check_firewall_source_ranges" {
  type = list(string)
}

variable "health_check_firewall_priority" {
  type = number
}

variable "load_balancer_tag" {
  type = list(string)
}

variable "load_balancer_proxy_name" {
  type = string
}

variable "load_balancer_ip_cidr" {
  type = string
}

variable "load_balancer_purpose" {
  type = string
}

variable "load_balancer_role" {
  type = string
}

variable "compute_instance_template_name" {
  type = string
}

variable "compute_instance_template_scheduling_auto_start" {
  type = bool
}

variable "compute_instance_template_scheduling_on_host_maintenance" {
  type = string
}

variable "compute_instance_template_disk_name" {
  type = string
}

variable "compute_instance_group_manager_name" {
  type = string
}

variable "compute_instance_group_manager_base_instance_name" {
  type = string
}

variable "compute_instance_group_manager_named_port_name" {
  type = string
}

variable "compute_instance_group_manager_named_port_port" {
  type = number
}

variable "compute_instance_group_manager_target_size" {
  type = number
}

variable "compute_instance_group_manager_init_delay_sec" {
  type = number
}

variable "load_balancer_health_check_name" {
  type = string
}

variable "load_balancer_health_check_check_interval_sec" {
  type = number
}

variable "load_balancer_health_check_timeout_sec" {
  type = number
}

variable "load_balancer_health_check_healthy_threshold" {
  type = number
}

variable "load_balancer_health_check_unhealthy_threshold" {
  type = number
}

variable "load_balancer_health_check_request_path" {
  type = string
}

variable "compute_auto_scaler_name" {
  type = string
}

variable "compute_auto_scaler_autoscaling_policy_max_replicas" {
  type = number
}

variable "compute_auto_scaler_autoscaling_policy_min_replicas" {
  type = number
}

variable "compute_auto_scaler_autoscaling_policy_cooldown_period" {
  type = number
}

variable "compute_auto_scaler_autoscaling_policy_cpu_target" {
  type = number
}

variable "static_ip_name" {
  type = string
}

variable "static_ip_address_type" {
  type = string
}

variable "load_balancer_backend_name" {
  type = string
}

variable "load_balancer_backend_scheme" {
  type = string
}

variable "load_balancer_backend_protocol" {
  type = string
}

variable "load_balancer_backend_session" {
  type = string
}

variable "load_balancer_backend_balancing" {
  type = string
}

variable "load_balancer_backend_timeout_sec" {
  type = number
}

variable "load_balancer_backend_capacity_scaler" {
  type = number
}

variable "google_compute_region_url_map_name" {
  type = string
}

variable "google_compute_region_target_https_proxy_name" {
  type = string
}

variable "google_compute_forwarding_rule_name" {
  type = string
}

variable "google_compute_forwarding_network_tier" {
  type = string
}

variable "google_compute_forwarding_load_balancing_scheme" {
  type = string
}

variable "ssl_cert_name" {
  type = string
}

variable "ssl_cert_key_path" {
  type = string
}

variable "ssl_cert_cert_path" {
  type = string
}

variable "google_compute_forwarding_rule_ip_protocol" {
  type = string
}

variable "load_balancer_front_end_port" {
  type = number
}
