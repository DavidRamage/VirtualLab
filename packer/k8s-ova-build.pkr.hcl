packer {
  required_plugins {
    virtualbox = {
      version = "~> 1"
      source  = "github.com/hashicorp/virtualbox"
    }
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = "~> 1"
    }
  }
}

source "virtualbox-ovf" "rocky-linux-base" {
  source_path      = "./ova/RockyLinuxBase.ova"
  ssh_username     = "root"
  ssh_password     = "RootAccess"
  communicator     = "ssh"
  shutdown_command = "echo 'packer' | sudo -S shutdown -P now"
}

build {
  sources = ["sources.virtualbox-ovf.rocky-linux-base"]
  provisioner "ansible" {
    playbook_file = "./ansible/k8s_provisioner.yaml"
  }
}
