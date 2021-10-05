# Creating a basic GKE (GCP managed kubernetes) cluster

In this document we intend to deploy and configure a basic GKE cluster with ingress (reverse proxy) support. The primary goal is to have a cluster up and ready for Onyxia [https://github.com/inseefrlab/onyxia](https://github.com/inseefrlab/onyxia).

## Setup cluster

Hashicorp maintains a great tutorial for getting started with terraform on GCP and deploying a basic Kubernetes cluster :  
https://learn.hashicorp.com/tutorials/terraform/gke

This tutorial will create a basic managed Kubernetes cluster.  
You can stop after the `Configure kubectl` step, we won't need the Kubernetes Dashboard.

Confirm everything is working by running `kubectl get nodes`. If you have (by default, 6) nodes listed as `Ready` then you are good to go !

## Install nginx ingress controller (reverse proxy)

Your cluster is up and running but there is, by default, no reverse proxy (Ingress controller) built-in. We will now deploy one : `ingress-nginx`.

https://kubernetes.github.io/ingress-nginx/deploy/#gce-gke

This should be a one-liner, applying the provided manifest using `kubectl`. 

After install, note the attributed `external-ip` corresponding to the `LoadBalancer` : `kubectl get svc -n ingress-nginx`. It may be `<pending>` for a few minutes. Once it has been allocated, note the `external-ip`. It will be used in the next step.

## Set up your own domain name

We will now direct our own domain name to our brand new reverse-proxy !  
One way to do this is to add a `A` DNS record pointing towards the `external-ip` previously created by `GCP` (the one that is used by the reverse proxy). Let's create a `wildcard` `A` entry so that we can expose multiple services.  
In our case, we will use `*.demo.insee.io` :

```DNS
*.demo.insee.io A 35.223.183.54
```

## Setup TLS (HTTPS) (optional)

Generate a wildcard certificate (Certbot documentation : https://certbot.eff.org/) :

```
certbot certonly --manual
```

Import it as a Kubernetes secret :

```
kubectl create secret tls wildcard -n ingress-nginx --key privkey.pem --cert fullchain.pem
```

Then patch the `ingress-nginx` deployment by adding `--default-ssl-certificate=ingress-nginx/wildcard` to the controller args.  
To do so you can use `kubectl edit` or copy the manifest used at installation, modify it and then `kubectl apply` it.

## ???

## Profit

You are now ready to deploy [https://github.com/inseefrlab/onyxia](https://github.com/inseefrlab/onyxia) !
