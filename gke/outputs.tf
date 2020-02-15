output "master_ip_addr" {
  value = google_container_cluster.primary.endpoint
}

/*output "client_certificate" {
  value = google_container_cluster.primary.* 
}*/



