# Setup a single Ubuntu VM as jumphole
* t3a-micro  
* ubuntu 18.04
* Add public key  
* Connect to it  

```
wget https://releases.hashicorp.com/terraform/0.11.14/terraform_0.11.14_linux_amd64.zip
sudo apt install unzip
unzip terraform_0.11.14_linux_amd64.zip
sudo mv terraform /usr/bin

sudo add-apt-repository ppa:ansible/ansible
sudo apt install ansible python-jmespath
```
