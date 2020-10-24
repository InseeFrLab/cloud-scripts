# Post-install

## Install Kubectl (client-side)  

### Download kubectl binary  
  
https://kubernetes.io/docs/tasks/tools/install-kubectl/  

### Get Kubectl credentials  

The easiest way to get the Kubernetes credentials tied to your google cloud account is : `gcloud container clusters get-credentials my-gke-cluster --region europe-west1-b`  

### Test  

```
kubectl get nodes
```  

## Install helm (client-side)

https://helm.sh/docs/intro/install/

## Install nginx-controller  (https://cloud.google.com/community/tutorials/nginx-ingress-gke)

### Setup TLS (HTTPS) (optional)

Generate a wildcard certificate (Certbot documentation : https://certbot.eff.org/) :  

```
certbot certonly --manual
```  

Import it as a Kubernetes secret :  

```
kubectl create secret tls wildcard --key privkey.pem --cert cert.pem
```

### Install using Helm

```
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install ingress-nginx ingress-nginx/ingress-nginx --set rbac.create=true --set controller.publishService.enabled=true --set controller.service.loadBalancerIP=<reserved-ip-address> --set controller.extraArgs.default-ssl-certificate="default/wildcard"
```  

## Install OIDC proxy  

GKE does not support OIDC authentication. It only provides authentication for `google` accounts.  
See [oidc](oidc/README.md) for instructions on installing `Kubernetes OIDC proxy`.
