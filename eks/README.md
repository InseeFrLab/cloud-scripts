# Creating a basic EKS (AWS managed kubernetes) cluster  

In this document we intend to deploy and configure a basic EKS cluster with ingress (reverse proxy) support. The primary goal is to have a cluster up and ready for Onyxia [https://github.com/onyxia](https://github.com/onyxia).  

## Setup cluster  

Hashicorp maintains a great tutorial for getting started with terraform on AWS and deploying a basic Kubernetes cluster :  
https://learn.hashicorp.com/tutorials/terraform/eks  

This tutorial will create a basic managed Kubernetes cluster.  
You can stop after the `Configure kubectl` step, we won't need the Kubernetes Dashboard.  

Confirm everything is working by running `kubectl get nodes`. If you have (by default, 3) nodes listed as `Ready` then you are good to go !

## Install nginx ingress controller (reverse proxy)

Your cluster is up and running but there is, by default, no reverse proxy (Ingress controller) built-in. We will now deploy one : `ingress-nginx`.  

https://kubernetes.github.io/ingress-nginx/deploy/#aws  

This should be a one-liner, applying the provided manifest using `kubectl`. You **don't** need `TLS TERMINATION IN AWS LOAD BALANCER (ELB)`.

After install, note the attributed `external-ip` : `kubectl get svc -n ingress-nginx`. It should be something like `xxx.elb.eu-west-1.amazonaws.com`.
It will be used during the next step.

## Set up your own domain name

We will now direct our own domain name to our brand new reverse-proxy !  
One way to do this is to add a `CNAME` DNS record pointing towards the `external-ip` previously created by `AWS` (the one that is used by the reverse proxy). Let's create a `wildcard` `CNAME` entry so that we can expose multiple services.  
In our case, we will use `*.demo.insee.io` :  

```DNS
*.demo.insee.io CNAME xxx.elb.eu-west-1.amazonaws.com
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

You are now ready to deploy [https://github.com/onyxia](https://github.com/onyxia) !