# Install Onyxia on AWS (EKS)

Step by step installation and configuration of Onyxia on AWS (using EKS).  
See https://github.com/InseeFrLab/onyxia/blob/master/INSTALL.md for general instructions on how to install and configure Onyxia.

## Setup cluster

https://learn.hashicorp.com/tutorials/terraform/eks

## Install nginx ingress controller (reverse proxy)

https://kubernetes.github.io/ingress-nginx/deploy/#aws

After install, note the attributed `external-ip` : `kubectl get svc -n ingress-nginx`. It should be something like `xxx.elb.eu-west-1.amazonaws.com`.
It will be used during the next step.

Note that, by default, `nginx-ingress` only handles `Ingresses` that have the `kubernetes.io/ingress.class=nginx` annotation so we will have to specify it in the next step.

## Install Onyxia

https://github.com/InseeFrLab/onyxia/blob/master/INSTALL.md#installation-1

```
helm install onyxia inseefrlab/onyxia --set ingress.annotations."kubernetes\.io/ingress\.class"=nginx --set ingress.enabled=true --set ingress.hosts[0].host=YOUREXTERNALIP.elb.eu-west-1.amazonaws.com
```

Congratulations, you now have a basic `Onyxia` datalab running on your brand new cluster :)  
Browse to `http://YOUREXTERNALIP.elb.eu-west-1.amazonaws.com` and deploy your first on-demand service !

This installation is very basic and has a lot of limitations.
We will now configure it to remove thoses limitations.

## Set up your own domain name

You probably want to configure you own domain name to expose Onyxia.  
TODO : add a CNAME
