provider "aws" {
  region = "eu-west-3"
  # make sure you have the credentials setup: https://www.terraform.io/docs/providers/aws/index.html#shared-credentials-file
}

data "http" "whatismyip" {
  url = "http://whatismyip.akamai.com/"
}

module "dcos-infrastructure" {
  source = "dcos-terraform/infrastructure/aws"
  version = "~> 0.2.0"

  cluster_name = "ssp-cloud-aws"

  admin_ips = [
    "${data.http.whatismyip.body}/32"]

  ssh_public_key_file = "~/.ssh/id_rsa.pub"
  #ssh_public_key = "${var.ssh_public_key}"
  #aws_key_name = "sschlott_default"

  dcos_instance_os = "centos_7.6"

  num_bootstrap = "1"
  bootstrap_instance_type = "t3.large"

  num_masters = "3"
  masters_instance_type = "t3.2xlarge"

  num_private_agents = "3"
  private_agents_instance_type = "t3.2xlarge"

  num_public_agents = "2"
  public_agents_instance_type = "t3.xlarge"

  tags = {
    owner = "ssp-cloud-team"
  }

  providers = {
    aws = "aws"
  }
}

module "dcos-ansible-bridge" {
  source = "dcos-terraform/dcos-ansible-bridge/localfile"
  version = "~> 0.1"

  bootstrap_ip = "${module.dcos-infrastructure.bootstrap.public_ip}"
  master_ips = [
    "${module.dcos-infrastructure.masters.public_ips}"]
  private_agent_ips = [
    "${module.dcos-infrastructure.private_agents.public_ips}"]
  public_agent_ips = [
    "${module.dcos-infrastructure.public_agents.public_ips}"]

  bootstrap_private_ip = "${module.dcos-infrastructure.bootstrap.private_ip}"
  master_private_ips = [
    "${module.dcos-infrastructure.masters.private_ips}"]
}

output "masters-dns-public" {
  value = "${module.dcos-infrastructure.lb.masters_dns_name}"
}
