
resource "kubernetes_deployment" "nginx-example" {
  metadata {
    name = "nginx-example"

    labels = {
      maintained_by = "terraform"
      app           = "nginx-example"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "nginx-example"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx-example"
        }
      }
      spec {
        container {
          image = "nginx:1.7.9"
          name  = "nginx-example"
        }
      }
    }
  }

  depends_on = [google_container_cluster.primary]
}

resource "kubernetes_ingress" "ingress" {
  metadata {
    name = "demo-ingress" 
    annotations = {
       "kubernetes.io/ingress.class" = "nginx"
    }
  }

spec {
    rule {
      host = "nginx.${var.domain_name}"
      http {
        path {
          backend {
            service_name = "nginx-example"
            service_port = 80
          }

          path = "/"
        }
      }
    }

    tls {
      hosts = ["nginx.${var.domain_name}"]
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
