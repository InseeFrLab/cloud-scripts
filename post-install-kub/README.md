# Post-install examples for a brand new k8s-cluster

## Setup argo-cd

- Change the `values.yaml` (apps/argo-cd) as needed. You can get rid of everything openid-connect related if you only intend to use the admin account.

```
kubectl create namespace argocd
helm install argocd . -f values.yaml -n argocd
```

To use argoCD, you can now port-forward the server and then access it from a browser :

```
kubectl port-forward svc/argocd-server -n argocd 8080:80
```

and browse to `http://localhost:8080`

Note that you can skip the step and directly apply argoCD contracts using kubectl.

## Setup Nginx ingress controller

- Change the `values.yaml` (apps/ingress-nginx) as needed.  
  Notes :
  - `default-ssl-certificate: ingress-nginx/kub-wildcard` you must create a tls secret containing your wildcard certificate or remove this. `kubectl create secret tls wildcard --key privkey.pem --cert cert.pem` can be used to import an existing tls certificate onto a kubernetes secret.
  - `nodeSelector: public: "true"`. Either label the nodes you intend to use as public nodes (using `kubectl label`) or remove this nodeSelector.

You are now ready to install nginx ingress controller. You can either use helm or use your newly configured argoCD to deploy !  
Modify the `argocd-deployments/ingress-nginx.yaml`

```
kubectl create namespace ingress-nginx
kubectl apply -f argocd-deployments/ingress-nginx.yaml -n argocd
```

check deployment status using `kubectl get Application -A`

## Setup k8s-onboarding

Same spirit, change the `values.yaml` and deploy using either helm or argoCD
