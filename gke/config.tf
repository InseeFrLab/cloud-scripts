provider "google" {
  credentials = file("~/.gcp/account.json")
  project     = "marine-compound-176220"
  region      = "us-central1"
}
