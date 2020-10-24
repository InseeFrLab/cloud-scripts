# Setup cluster

## Setup terraform

Latest Terraform version should be ok. Tested with 0.13.5.  
```
https://releases.hashicorp.com/terraform/0.13.5/terraform_0.13.5_linux_amd64.zip
```

## Used providers

https://www.terraform.io/docs/providers/google/index.html

Tested with provider `3.44.0`

To install required modules :  
```
terraform init -upgrade
```


### Configuration  

* Create a service account (https://console.cloud.google.com/iam-admin/serviceaccounts).  
* TODO : list permissions needed for the service account. Creating a `Project owner` service account is insecure but effective.
* Export account key in JSON format  
* Put JSON key on `~/gcp/account.json`
* Modify the `config.tf` file to change the project name

### Run  

```
terraform apply -var domain_name=example.com
```  

Takes ~6 minutes  

Input :  
* `projectid` : the project to work in
* `domain_name` : the base domain name to use (for dns configuration & ingress). Defaults to `example.com` (you probably want to change it).  

Note : you can also change the variables directly in `variables.tf`.

Output : 
* `master ip` (which is the `apiserver` you are probably looking for)
* `reserved_ip_address` (the reverse proxy ip)

### Post install

To use kubectl : `gcloud container clusters get-credentials my-gke-cluster --region europe-west1-b`
