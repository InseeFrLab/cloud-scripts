* go to folder and clone https://github.com/dcos/dcos-ansible
* Install Terraform (needs to the newest version of 0.11.x - e.g. from here https://releases.hashicorp.com/terraform/0.11.14/)
* `terraform init -upgrade`
* `terraform plan` , `terraform apply`
* go to `/dcos-ansible`
* run `ansible all -m ping` to test connectivity 
* run `ansible-playbook dcos.yaml` to run the playbook
* 