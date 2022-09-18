terraform {
  backend "gcs" {
    prefix = "default/terraform"
  }
}
