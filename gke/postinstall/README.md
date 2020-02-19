# Post-install

## Install nginx-controller

https://cloud.google.com/community/tutorials/nginx-ingress-gke

### Create a wildcard cert

```
certbot certonly --manual
```

### Import it as a kubernetes secret

```
kubectl create secret tls lab-wildcard --key privkey.pem --cert cert.pem
```

TODO : this secret should probably be in a more secured namespace

### (client-side) Install helm

Download helm (tested with 3.1.0) : https://github.com/helm/helm/releases

```
helm repo add stable https://kubernetes-charts.storage.googleapis.com
helm repo update
```

### Install nginx ingress controller

```
helm install nginx-ingress stable/nginx-ingress --set rbac.create=true --set controller.publishService.enabled=true --set controller.service.loadBalancerIP=<reserved-ip-address> --set controller.extraArgs.default-ssl-certificate="default/lab-wildcard"
```

### Install OIDC proxy  

See [oidc](oidc/README.md)
