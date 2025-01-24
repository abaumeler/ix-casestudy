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
}