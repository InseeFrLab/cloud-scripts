provider "google" {
  credentials = file("~/.gcp/account.json")
  project     = "projet-insee-poc"
  region      = "europe-west1"
}

provider "kubernetes" {
  version                = "1.10"
  load_config_file       = false
  host                   = "https://${google_container_cluster.primary.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
}


data "google_client_config" "default" {
}

