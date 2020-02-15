
resource "kubernetes_pod" "nginx-example" {
  metadata {
    name = "nginx-example"

    labels = {
      maintained_by = "terraform"
      app           = "nginx-example"
    }
  }

  spec {
    container {
      image = "nginx:1.7.9"
      name  = "nginx-example"
    }
  }

  depends_on = [google_container_cluster.primary]
}

resource "kubernetes_ingress" "ingress" {
  metadata {
    name = "static-ingress" 
    annotations = {
       "kubernetes.io/ingress.global-static-ip-name": "kubernetes-cluster-ip-address"
    }
  }

spec {
    backend {
      service_name = "nginx-example"
      service_port = 80
    }

    rule {
      http {
        path {
          backend {
            service_name = "nginx-example"
            service_port = 80
          }

          path = "/*"
        }
      }
    }
  }

  depends_on = [google_container_cluster.primary]
}

resource "kubernetes_service" "nginx-example" {

   metadata {
    name = "nginx-example"
  }
  spec {
    selector = {
      app = "nginx-example"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "NodePort"
  }

  depends_on = [google_container_cluster.primary]
}
