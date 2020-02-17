
resource "google_compute_global_address" "kubernetes_cluster" {
 name = "kubernetes-cluster-ip-address"
}

output "reserved_ip_address" {
  value = google_compute_global_address.kubernetes_cluster.address
}



resource "google_dns_managed_zone" "managed_zone" {
 count = "1"
 dns_name = "lab.sspcloud.fr."
 name = "managed-zone"
 description = "WIP"
}

resource "google_dns_record_set" "index" {
 managed_zone = "managed-zone"
 name = "lab.sspcloud.fr."
 type = "A"
 ttl = 300
 rrdatas = ["${google_compute_global_address.kubernetes_cluster.address}"]
}

resource "google_dns_record_set" "wildcard_index" {
 managed_zone = "managed-zone"
 name = "*.lab.sspcloud.fr."
 type = "A"
 ttl = 300
 rrdatas = ["${google_compute_global_address.kubernetes_cluster.address}"]
}
