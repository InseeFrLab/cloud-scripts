
resource "google_compute_global_address" "kubernetes_cluster" {
 name = "kubernetes-cluster-ip-address"
}

output "reserved_ip_address" {
  value = google_compute_global_address.kubernetes_cluster.address
}



/*resource "google_dns_managed_zone" "my_company_zone" {
 count = "1"
 dns_name = "xxxxx.fr"
 name = "my-company-zone"
 description = "WIP"
}

resource "google_dns_record_set" "my_awesome_service" {
 managed_zone = "my-company-zone"
 name = "xxxxx.fr"
 type = "A"
 ttl = 300
 rrdatas = ["${google_compute_global_address.kubernetes_cluster.address}"]
}*/
