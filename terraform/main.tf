resource "digitalocean_droplet" "client-1" {
    image = "ubuntudesktopgno"
    name = "client-1"
    region = "fra1"
    size = "s-1vcpu-2gb"
    ssh_keys = [
        data.digitalocean_ssh_key.terraform-key.id
    ]
    connection {
        host = self.ipv4_address
        user = "root"
        type = "ssh"
        private_key = file(var.pvt_key)
        timeout = "2m"
    }
}

resource "digitalocean_droplet" "server-1" {
    image = "almalinux-8-x64"
    name = "server-1"
    region = "fra1"
    size = "s-1vcpu-1gb"
    ssh_keys = [
        data.digitalocean_ssh_key.terraform-key.id
    ]
    connection {
        host = self.ipv4_address
        user = "root"
        type = "ssh"
        private_key = file(var.pvt_key)
        timeout = "5m"
    }
    provisioner "remote-exec" {
        inline = [
      "sudo useradd -m -s /bin/bash ansible",
      "sudo mkdir -p /home/ansible/.ssh",
      "sudo chmod 700 /home/ansible/.ssh",
      "sudo cp /root/.ssh/authorized_keys /home/ansible/.ssh/",
      "sudo chown -R ansible:ansible /home/ansible/.ssh",
      "echo 'ansible ALL=(ALL) NOPASSWD:ALL' | sudo tee -a /etc/sudoers",
      "rpm --import https://repo.almalinux.org/almalinux/RPM-GPG-KEY-AlmaLinux",
      "sudo dnf -y update",
      "sudo dnf -y upgrade",
      "sudo dnf -y install python39"
        ]
    }
}

resource "digitalocean_droplet" "server-2" {
    image = "almalinux-8-x64"
    name = "server-2"
    region = "fra1"
    size = "s-1vcpu-1gb"
    ssh_keys = [
        data.digitalocean_ssh_key.terraform-key.id
    ]
    connection {
        host = self.ipv4_address
        user = "root"
        type = "ssh"
        private_key = file(var.pvt_key)
        timeout = "5m"
    }
    provisioner "remote-exec" {
        inline = [
      "sudo useradd -m -s /bin/bash ansible",
      "sudo mkdir -p /home/ansible/.ssh",
      "sudo chmod 700 /home/ansible/.ssh",
      "sudo cp /root/.ssh/authorized_keys /home/ansible/.ssh/",
      "sudo chown -R ansible:ansible /home/ansible/.ssh",
      "echo 'ansible ALL=(ALL) NOPASSWD:ALL' | sudo tee -a /etc/sudoers",
      "rpm --import https://repo.almalinux.org/almalinux/RPM-GPG-KEY-AlmaLinux",
      "sudo dnf -y update",
      "sudo dnf -y upgrade",
      "sudo dnf -y install python39"
        ]
    }
}


# Create the dynamic Ansible inventory file
resource "local_file" "ansible_inventory" {
  filename = "../ansible/inventory.yml" # The path where inventory.yml will be saved

  content = <<-EOT
[servers]
${digitalocean_droplet.server-1.ipv4_address}
${digitalocean_droplet.server-2.ipv4_address}
  EOT
}

output "ansible_inventory_file" {
  value = local_file.ansible_inventory.filename
}

output "client-1" {
  value = digitalocean_droplet.client-1.ipv4_address
}
