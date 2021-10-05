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

Modify `terraform.tfvars.json` according to your needs.  
See `variables.tf` for the list and description of variables.  

```
terraform apply
```  

Takes ~6 minutes  

Output : 
* `master ip` : the `apiserver` IP 
* `reserved_ip_address` : the ip that will be used for the reverse proxy
* `zone` : DNS zones that you need to set on your DNS provider

### Important note  

Make sure to store the `terraform.tfstate` (or `terraform.tfstate.backup`) file (and keep it up to date).  
Warning : this file contains secrets, you should treat it as a private file.  
If you ever lose access to it, you won't be able to easily make changes to your infrastructure.  
See https://medium.com/@abtreece/recovering-terraform-state-69c9966db71e for more details.

### Post install

See [postinstall](postinstall/README.md) for suggestions on how to enjoy your brand new cluster :)
