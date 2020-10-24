
resource "google_compute_address" "kubernetes_cluster" {
  name   = "kubernetes-cluster-ip-address"
  region = var.region
}

output "reserved_ip_address" {
  value = google_compute_address.kubernetes_cluster.address
}

resource "google_dns_managed_zone" "managed_zone" {
  dns_name    = "${var.domain_name}."
  name        = "managed-zone"
  description = "WIP"
}

resource "google_dns_record_set" "index" {
  managed_zone = "managed-zone"
  name         = "${var.domain_name}."
  type         = "A"
  ttl          = 300
  rrdatas      = [google_compute_address.kubernetes_cluster.address]
  depends_on   = [google_dns_managed_zone.managed_zone]
}

resource "google_dns_record_set" "wildcard_index" {
  managed_zone = "managed-zone"
  name         = "*.${var.domain_name}."
  type         = "A"
  ttl          = 300
  rrdatas      = [google_compute_address.kubernetes_cluster.address]
  depends_on   = [google_dns_managed_zone.managed_zone]
}
