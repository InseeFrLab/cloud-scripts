# Setup OIDC authentication 

GKE (and other cloud providers) does not support oidc authentication for the apiserver and we have no control over the master nodes configuration.  
So we have to use third-party tools to setup a proxy apiserver.  

https://github.com/jetstack/kube-oidc-proxy

## Install using helm

The chart is not (yet ? https://github.com/jetstack/kube-oidc-proxy/issues/123) officially available on public repositories but can be downloaded from github.  

```
git clone https://github.com/jetstack/kube-oidc-proxy
cd kube-oidc-proxy/deploy/charts/kube-oidc-proxy
```  

InseeFRLab also provides a public mirror for the chart (warning : the mirror may be out of date, feel free to submit an issue / PR). See https://github.com/inseefrlab/helm-charts

The minimum configuration is :  

```
oidc:
  clientId: my-client
  issuerUrl: https://accounts.google.com
  usernameClaim: email
```

So we can go ahead and install it :  

```
helm install -f conf.yaml oidc-kube-proxy .
```

If you want to fallback to the GKE / EKS default auth you can enable [token passthrough feature](https://github.com/jetstack/kube-oidc-proxy/blob/master/docs/tasks/token-passthrough.md) :  
```
--set tokenPassthrough.enabled=true
```

