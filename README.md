# Inventx Case Study Environment

## Prerequisites
- WSL with Ubuntu on managed device
- Digital Ocean account with payment configured
- Digital Ocean access token saved as `$DO_PAT` environment variable in WSL

## Setup Instructions

**IMPORTANT**: All commands in this guide should be run from the main directory (`ix-casestudy`).

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
host_key_checking = False     
```

#### Install Additional Components
- [Ansible Terraform provider](https://github.com/ansible/terraform-provider-ansible)
- RealVNC viewer: Download .deb from [RealVNC website](https://www.realvnc.com/de/connect/download/viewer/linux/) and install with `sudo dpkg -i <package>`

### 2. Deploy Environment

```bash
# Initialize Terraform (required before first deployment)
terraform -chdir=terraform init

# Plan infrastructure
terraform -chdir=terraform plan -var "do_token=${DO_PAT}"

# Create infrastructure (this will also generate SSH keys and configure the client)
terraform -chdir=terraform apply -var "do_token=${DO_PAT}"
```

The Terraform script will:
1. Generate a new SSH key pair
2. Save the keys to ansible/ssh-keys/
3. Create the required infrastructure
4. Configure the client automatically using Ansible

### 3. Manual Configuration Steps

**IMPORTANT**: Before a candidate can use the environment, you must:
1. SSH to the client machine as root to start autoconfiguration and complete setup:
   ```bash
   ssh -i ansible/ssh-keys/id_rsa root@client-ip
   ```
2. Note the VNC credentials displayed during setup - these will be needed for candidate access
3. Run the client-setup playbook to prepare the environment for the candidate:
   ```bash
   ansible-playbook -i ansible/inventory.yml ansible/client-setup.yml --private-key=ansible/ssh-keys/id_rsa
   ```
4. Deploy any needed case study playbooks (detailed in section 4)

Once the environment is ready, provide the candidate with:
1. Instructions to launch VNC viewer: `vncviewer` or use any VNC client
2. Connection details: `client-ip:5900` and the VNC credentials
3. Details about the specific case study they will be working on

### 4. Deployment of Study Cases

Run ansible playbooks as needed to deploy the desired study cases using the generated keys:
```bash
ansible-playbook -i ansible/inventory.yml ansible/case_CASENAME.yml --private-key=ansible/ssh-keys/id_rsa
```

### 5. Destroy Environment

When finished, remove the environment to prevent unwanted costs:
```bash
terraform -chdir=terraform destroy -var "do_token=${DO_PAT}"
```