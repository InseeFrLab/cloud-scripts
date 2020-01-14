* go to folder and clone https://github.com/dcos/dcos-ansible
* terraform init -upgrade
* go to /dcos-ansible
* run `ansible all -m ping` to test connectivity 
* run `ansible-playbook dcos.yaml` to run the playbook
* 