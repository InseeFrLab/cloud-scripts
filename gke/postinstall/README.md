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


### Install via helm

```
helm install --name nginx-ingress stable/nginx-ingress --set rbac.create=true --set controller.publishService.enabled=true --set controller.service.loadBalancerIP=<reserved-ip-address> --set controller.extraArgs.default-ssl-certificate="lab-wildcard"
```


