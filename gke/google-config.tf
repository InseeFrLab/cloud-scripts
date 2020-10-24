provider "google" {
  credentials = file("~/.gcp/account2.json")
  project     = var.projectid
  region      = var.region
}

data "google_client_config" "default" {
}

