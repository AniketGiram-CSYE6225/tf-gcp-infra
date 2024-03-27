resource "google_pubsub_schema" "UserSchema" {
  name       = "UserSchema"
  type       = "AVRO"
  definition = <<JSON
{
  "type": "record",
  "name": "Avro",
  "fields": [
    {
      "name": "userId",
      "type": "string"
    },
    {
      "name": "username",
      "type": "string"
    },
    {
      "name": "firstName",
      "type": "string"
    }
  ]
}
JSON
}

resource "google_pubsub_topic" "verifyUser" {
  name       = "verify_email"
  depends_on = [google_pubsub_schema.UserSchema]
  schema_settings {
    schema   = "projects/nscc-prod-2404/schemas/UserSchema"
    encoding = "JSON"
  }
  message_retention_duration = "604800s"
}
