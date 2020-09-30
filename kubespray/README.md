# Kubespray  

Quick notes on deploying Kubernetes using Kubespray.  
Walkthrough uses VMs on GCP for testing purposes but the goal is to deploy a on-premise cluster.  

## Gather the nodes  

3 types of nodes :   
* Master nodes (they manage the cluster). Suggested : 3 masters. Tested with `e2-medium` (2vCPU, 4GB memory).
* Worker nodes (they run the workloads). Suggested : 2 nodes. Tested with `e2-standard-2` (2vCPU, 8GB memory).  
* Bootstrap node : not part of the cluster but really useful to coordoniate the installation, manage the cluster and access it. Suggested : 1 node. Tested with `e2-medium` (2vCPU, 4GB memory).

OS :  
We chose to use `centos-7` on all nodes.  

SSH :  
The bootstrap node should be able to connect using `SSH` to each of the nodes.  
This has some network implications (see below) and also authentication implications.  
We created a SSH key pair and added the public key to each of the node :  
```
gcloud compute instances add-metadata master1 --zone=europe-west1-b  --metadata-from-file ssh-keys=key.txt
```  
And then added the private key to the bootstrap node.

Networking :  
Good practice is to separate the nodes in 3 networks :  
* Master network (in this walkthough we will be using `192.168.254.0/24`)  
* Workers network (in this walkthough we will be using `192.168.253.0/24`)  
* Admin network (in this walkthough we will be using `192.168.255.0/24`)  

In GCP, this is done by setting up VPC networks.  

Surprise (at least for us at the time) : by default, communication inside a VPC is disabled. We should setup firewall rules to allow internal traffic.  
For each network, setup a rule like this :  
* Direction of traffic : ingress  
* All instances of this network  
* Source ip ranges : `192.168.254.0/24` (for masters, change for each network)  
* Allow all  

Then we need to setup communication between networks.  
For simplicity, we used VPC network peering to create links between each VPC. Note that each link must be reciprocated so that results in a total of `6` (3*2) VPC peering's.  

## Install prerequisites on nodes   

For each master and worker node, we have to install and disable some things.  
We followed this tutorial : https://dzone.com/articles/kubespray-10-simple-steps-for-installing-a-product  

One-liner for master nodes :  
```
firewall-cmd --permanent --add-port=6443/tcp && firewall-cmd --permanent --add-port=2379-2380/tcp && firewall-cmd --permanent --add-port=10250/tcp && firewall-cmd --permanent --add-port=10251/tcp && firewall-cmd --permanent --add-port=10252/tcp && firewall-cmd --permanent --add-port=10255/tcp && firewall-cmd --reload && modprobe br_netfilter && echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables && sysctl -w net.ipv4.ip_forward=1
```  

One-liner for worker nodes :  
```
firewall-cmd --permanent --add-port=10250/tcp && firewall-cmd --permanent --add-port=10255/tcp && firewall-cmd --permanent --add-port=30000-32767/tcp && firewall-cmd --permanent --add-port=6783/tcp && firewall-cmd  --reload && echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables && sysctl -w net.ipv4.ip_forward=1
```

Then you have to install `ansible` on the bootstrap node :  
```
sudo yum install epel-release && sudo yum install ansible && easy_install pip && pip2 install jinja2 --upgrade && sudo yum install python36 –y
```

Nodes are now ready for installation !

## Setup inventory  

The inventory is the list of targets that will be used by ansible to install the cluster.  
So that should contain our masters and our workers.  
The inventory is a plain `YAML` file (`.ini` files are also supported).  

You can start by copying the inventory/sample folder which will provide you with a sample configuration.

Example (using calico as cluster's network):  
```YAML
all:
  hosts:
    master1:
      ansible_host: 192.168.254.35
      ip: 192.168.254.35
      access_ip: 192.168.254.35
    master2:
      ansible_host: 192.168.254.36
      ip: 192.168.254.36
      access_ip: 192.168.254.36
    master3:
      ansible_host: 192.168.254.37
      ip: 192.168.254.37
      access_ip: 192.168.254.37
    node1:
      ansible_host: 192.168.253.55
      ip: 192.168.253.55
      access_ip: 192.168.253.55
    node2:
      ansible_host: 192.168.253.56
      ip: 192.168.253.56
      access_ip: 192.168.253.56
  children:
    kube-master:
      hosts:
        master1:
        master2:
        master3:
    kube-node:
      hosts:
        node1:
        node2:
    etcd:
      hosts:
        master1:
        master2:
        master3:
    k8s-cluster:
      children:
        kube-master:
        kube-node:
    calico-rr:
      hosts: {}
```  

To confirm that the inventory is fine and that all nodes are reachable :  
```
ansible all -i hosts.yml -m ping
```

## Cluster's configuration  

Configuration is done inside the `group_vars` folder.  
Especially, the `inventory/my-cluster/group_vars/k8s-cluster/k8s-cluster.yml` which is the main configuration file.  

Main configuration we changed were :  
* `kube_version: v1.19.2` (see https://github.com/kubernetes/kubernetes/releases)  
* `kube_oidc_auth: true` (and `kube_oidc_X` variables)  

We used the default network : `calico`

## Let's gooooooo  

We are now all set to install.  
The playbook to run is `cluster.yml`. 

`ansible-playbook -i inventory/my-cluster/hosts.yml --become --become-user=root cluster.yml`

Note : `--become` and `--become-user` are needed as the account we used on worker / master nodes was not `root`. You may not need it.  

## Hot-changing the configuration  

To change the configuration while the cluster is live, we should use the `upgrade-cluster.yml` playbook :  
`ansible-playbook -i inventory/my-cluster/hosts.yml --become --become-user=root upgrade-cluster.yml`  

Successfully tested with enabling the `openidconnect` authentification on apiserver.

## Adding a node  

This is supposed to be done like this :  
* Setup the new node (including prerequisites, see above)  
* Add the new node to the inventory  
* `ansible-playbook -i inventory/my-cluster/hosts.yml --become --become-user=root facts.yml`
* `ansible-playbook -i inventory/my-cluster/hosts.yml --become --become-user=root scale.yml --limit=newnode` (the limit is supposed to reduce total time my making sure the other nodes are untouched)  

This failed for some reason (?).  
`ansible-playbook -i inventory/my-cluster/hosts.yml --become --become-user=root upgrade-cluster.yml` worked.  
It's unclear what happened and which command (`scale.yml` ? `upgrade-cluster.yml` ? Both ?) should really be used.  


