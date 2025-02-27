# Inventx Case Study Environment

## Prerequisites
- WSL with Ubuntu on managed device
- Digital Ocean account with payment configured
- Digital Ocean access token saved as `$DO_PAT` environment variable in WSL
- SSH key-pair generated in WSL at `$HOME/.ssh/id_rsa.pub` and `$HOME/.ssh/id_rsa` (exclusively for this project)
- Public key added to Digital Ocean account

## Setup Instructions

### 1. WSL Configuration

#### Install Terraform
Follow [Digital Ocean's guide](https://www.digitalocean.com/community/tutorials/how-to-use-terraform-with-digitalocean) and set `DO_PAT` environment variable.

#### Install Ansible
```bash
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible
```

#### Configure Ansible
Create `.ansible.cfg` in your WSL home directory:
```ini
[defaults]
inventory = inventory
log_path = ./logs/ansible.log
retry_files_enabled = False
gathering = explicit
any_errors_fatal = True
stdout_callback = debug
remote_user = ansible
private_key_file = /home/<user>/.ssh/id_rsa
host_key_checking = False     
```

#### Install Additional Components
- [Ansible Terraform provider](https://github.com/ansible/terraform-provider-ansible)
- RealVNC viewer: Download .deb from [RealVNC website](https://www.realvnc.com/de/connect/download/viewer/linux/) and install with `sudo dpkg -i <package>`

### 2. Deploy Environment

```bash
# Copy SSH private key
cp $HOME/.ssh/id_rsa ansible/ssh-keys/id_rsa

# Plan infrastructure
terraform plan -var "do_token=${DO_PAT}" -var "pvt_key=$HOME/.ssh/id_rsa" -var "pub_key=$HOME/.ssh/id_rsa.pub"

# Create infrastructure
terraform apply -var "do_token=${DO_PAT}" -var "pvt_key=$HOME/.ssh/id_rsa" -var "pub_key=$HOME/.ssh/id_rsa.pub"

# Configure client
ansible-playbook client-setup.yml -i inventory.yml
```

### 3. Manual Configuration Steps

1. SSH to client machine as root to start autoconfiguration
2. Note the VNC credentials displayed during setup
3. Launch VNC viewer: `vncviewer` or use any VNC client
4. Connect to `client-ip:5900` and complete desktop environment setup
5. Run ansible playbooks to deploy specific study cases
6. Provide candidate with connection & case details

### 4. Deployment of Study Cases

Run ansible playbooks as needed to deploy the desired study cases.

### 5. Destroy Environment

When finished, remove the environment to prevent unwanted costs:
```bash
terraform destroy -var "do_token=${DO_PAT}" -var "pvt_key=$HOME/.ssh/id_rsa" -var "pub_key=$HOME/.ssh/id_rsa.pub"
```