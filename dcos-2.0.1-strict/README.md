* go to folder and clone https://github.com/dcos/dcos-ansible
* Install Terraform (needs to the newest version of 0.11.x - e.g. from here https://releases.hashicorp.com/terraform/0.11.14/)
* `terraform init -upgrade`
* `terraform plan` , `terraform apply`
* `bash -x prepare_ansible.sh`
* go to `/dcos-ansible`
* run `ansible all -m ping` to test connectivity 
* run `ansible-playbook dcos.yml` to run the playbook

* go to your base folder and get the DC/OS URL with `terraform output masters-dns-public` (add `https://` in front)
