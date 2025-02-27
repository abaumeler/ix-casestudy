terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    tls = {
      source = "hashicorp/tls"
      version = "~> 4.0"
    }
    null = {
      source = "hashicorp/null"
      version = "~> 3.2"
    }
  }
}

variable "do_token" {}

provider "digitalocean" {
  token = var.do_token
}

# Generate a new SSH key pair
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Save the private key to the ansible/ssh-keys directory
resource "local_file" "private_key" {
  content         = tls_private_key.ssh_key.private_key_pem
  filename        = "../ansible/ssh-keys/id_rsa"
  file_permission = "0600"
}

# Save the public key to the ansible/ssh-keys directory
resource "local_file" "public_key" {
  content         = tls_private_key.ssh_key.public_key_openssh
  filename        = "../ansible/ssh-keys/id_rsa.pub"
  file_permission = "0644"
}

# Upload the SSH key to DigitalOcean
resource "digitalocean_ssh_key" "terraform_key" {
  name       = "terraform-key-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  public_key = tls_private_key.ssh_key.public_key_openssh
}