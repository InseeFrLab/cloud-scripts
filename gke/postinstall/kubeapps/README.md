# Kubeapps

https://github.com/kubeapps/kubeapps

## Installation

```
kubectl create namespace kubeapps
helm install kubeapps --namespace kubeapps bitnami/kubeapps --set useHelm3=true --set ingress.enabled=true --set ingress.hostname=kubeapps.lab.sspcloud.fr --set ingress.annotations."kubernetes\.io/ingress\.class"=nginx
```

