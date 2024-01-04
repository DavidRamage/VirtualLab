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

source "virtualbox-ovf" "ubuntu-linux-base" {
  source_path      = "./ova/UbuntuPackerImage.ova"
  ssh_username     = "user"
  ssh_password     = "vagrant"
  communicator     = "ssh"
  shutdown_command = "echo 'vagrant' | sudo -S shutdown -P now"
}

build {
    sources = ["sources.virtualbox-ovf.ubuntu-linux-base"]
    provisioner "ansible" {
      playbook_file = "./ansible/k8s_provisioner.yaml"
      extra_arguments = [ "--extra-vars", "ansible_become_pass='vagrant'"]
    }
  post-processors {
    post-processor "vagrant" {
      keep_input_artifact = true
      provider_override = "virtualbox"
    }
    post-processor "shell-local" {
      inline = [ "vagrant box add ubuntu-linux-kubernetes packer_ubuntu-linux-base_virtualbox_amd64.box" ]
    }
  }
}
