# Post-install

## Install helm (client-side)

Download helm : https://github.com/helm/helm/releases

## Install nginx-controller

https://cloud.google.com/community/tutorials/nginx-ingress-gke

### Optional : setup TLS (HTTPS)

Generate a wildcard certificate (Certbot documentation : https://certbot.eff.org/) :  

```
certbot certonly --manual
```  

Import it as a Kubernetes secret :  

```
kubectl create secret tls wildcard --key privkey.pem --cert cert.pem
```

### Install nginx ingress controller using Helm

```
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install ingress-nginx ingress-nginx/ingress-nginx --set rbac.create=true --set controller.publishService.enabled=true --set controller.service.loadBalancerIP=<reserved-ip-address> --set controller.extraArgs.default-ssl-certificate="default/wildcard"
```  

## Install OIDC proxy  

GKE does not support OIDC authentication. It only provides authentication for `google` accounts.  
See [oidc](oidc/README.md) for instructions on installing `Kubernetes OIDC proxy`.
