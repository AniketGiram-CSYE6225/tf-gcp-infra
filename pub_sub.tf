resource "google_pubsub_schema" "UserSchema" {
  name       = var.pub_sub_schema_name
  type       = var.pub_sub_schema_type
  definition = var.pub_sub_user_schema
}

resource "google_pubsub_topic" "verifyUser" {
  name       = var.pub_sub_topic_name
  depends_on = [google_pubsub_schema.UserSchema]
  schema_settings {
    schema   = var.pub_sub_schema_setting_schema
    encoding = var.pub_sub_schema_encoding
  }
  message_retention_duration = var.pub_sub_message_retation_duration
}
