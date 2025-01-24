resource "digitalocean_droplet" "client-1" {
    image = "ubuntu-24-10-x64"
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