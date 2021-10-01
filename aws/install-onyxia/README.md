# Install Onyxia on AWS (EKS)

Step by step installation and configuration of Onyxia on AWS (from scratch, using EKS).  
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

[1-basic.yaml](values/1-basic.yaml)
```
helm install onyxia inseefrlab/onyxia -f values/1-basic.yaml
```

Congratulations, you now have a basic `Onyxia` datalab running on your brand new cluster :)  
Browse to `http://YOUREXTERNALIP.elb.eu-west-1.amazonaws.com` and deploy your first on-demand service !

This installation is very basic and has a lot of limitations.
We will now configure it to remove thoses limitations.

## Set up your own domain name

You probably want to configure you own domain name to expose Onyxia.  
One way to do this is to add a `CNAME` DNS record pointing towards the `external-ip` previously created by `AWS` (the one that is used by the reverse proxy). Let's create a `wildcard` `CNAME` entry so that we can use it to expose both Onyxia and the services it will create.  
For the rest of this tutorial, we will use `*.demo.insee.io` :  

```DNS
*.demo.insee.io CNAME xxx.elb.eu-west-1.amazonaws.com
```  

We can now update `Onyxia` to use this domain name :  

[2-domainname.yaml](values/2-domainname.yaml)
```
helm upgrade onyxia inseefrlab/onyxia -f values/2-domainname.yaml
```  

Onyxia is now available at `http://onyxia.demo.insee.io`  

## Set up authentication (openidconnect)  

We strongly recommend you don't use Onyxia without any authentication configured.  
Onyxia supports `openidconnect`.  

### Set up keycloak  

If you already have a Keycloak instance running or an existing `openidconnect` provider, you can skip this step.  

An example of Keycloak deployment can be found [here](keycloak)  

Create a realm (in this tutorial we choose `onyxia-demo`) and a client (we choose `onyxia-client`).  
Here are some client settings :  

* ROOT url : https://onyxia.demo.insee.io
* Valid redirect URIs : http://onyxia.demo.insee.io, https://onyxia.demo.insee.io
* Web-origins : http://onyxia.demo.insee.io, https://onyxia.demo.insee.io  

Also create at least one user with a password set.

### Activate openidconnect in Onyxia  

[3-oidc.yaml](values/3-oidc.yaml)
```
helm upgrade onyxia inseefrlab/onyxia -f values/3-oidc.yaml
```  

TODO : API configuration  

