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
        timeout = "2m"
    }
    provisioner "remote-exec" {
        inline = [
        "sudo useradd -m -s /bin/bash ansible",
        "echo 'ansible:password' | sudo chpasswd",
        "echo 'ansible ALL=(ALL) NOPASSWD:ALL' | sudo tee -a /etc/sudoers"
        ]
    }
}

# Create the dynamic Ansible inventory file
resource "local_file" "ansible_inventory" {
  filename = "../inventory.yml" # The path where inventory.yml will be saved

  content = <<-EOT
    all:
      hosts:
        server:
          ansible_host: ${digitalocean_droplet.server-1.ipv4_address}
  EOT
}

output "ansible_inventory_file" {
  value = local_file.ansible_inventory.filename
}