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
