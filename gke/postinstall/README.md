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


### Install helm tiller

```
kubectl --namespace kube-system create sa tiller

# create a cluster role binding for tiller
kubectl create clusterrolebinding tiller \
    --clusterrole cluster-admin \
    --serviceaccount=kube-system:tiller

# initialized helm within the tiller service account
helm init --service-account tiller
```

### Install nginx ingress controller

```
helm install --name nginx-ingress stable/nginx-ingress --set rbac.create=true --set controller.publishService.enabled=true --set controller.service.loadBalancerIP=<reserved-ip-address> --set controller.extraArgs.default-ssl-certificate="default/lab-wildcard"
```


