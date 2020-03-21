# Setup cluster

## Setup terraform

Latest Terraform version should be ok. Tested with 0.12.20.  
```
wget https://releases.hashicorp.com/terraform/0.12.20/terraform_0.12.20_linux_amd64.zip
```

## Used providers

https://www.terraform.io/docs/providers/google/index.html

Tested with provider `3.8`

https://www.terraform.io/docs/providers/kubernetes/index.html

Tested with provider `1.10`

To install required modules :  
```
terraform init -upgrade
```


### Configuration  

* Create a service account (https://console.cloud.google.com/iam-admin/serviceaccounts).  
* Export account key in JSON format  
* Put JSON key on `~/gcp/account.json`
* Modify the `config.tf` file to change the project name

### Run  

```
terraform apply -var domain_name=example.com
```

Takes ~6 minutes  

Input :
* `domain_name` : the base domain name to use (for dns configuration & ingress). Defaults to `demo.dev.sspcloud.fr` (you probably want to change it).

Output : 
* `master ip` (which is the `apiserver` you are looking for)
* `reserved_ip_address` (the ingress ip, should have a basic nginx deployed)

### Post install

To use kubectl : `gcloud container clusters get-credentials my-gke-cluster --region europe-west1-b`
