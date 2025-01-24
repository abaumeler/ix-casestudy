# Inventx Case Study Environment

## Setup
### Pre-Reqs
- WSL with Ubuntu set up on managed device
- Digital Ocean Account with payment set up
- Digital Ocean access token, save as $DO_PAT in WSL
- SSH key-pair generated on the WSL
- Public key added to Digital Ocean account

### Setup WSL 
1. Install terraform to WSL as per [here](https://www.digitalocean.com/community/tutorials/how-to-use-terraform-with-digitalocean)
2. Install ansible to WSL as  per [here](https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html#installing-ansible-on-ubuntu), in short: 
```
$ sudo apt update
$ sudo apt install software-properties-common
$ sudo add-apt-repository --yes --update ppa:ansible/ansible
$ sudo apt install ansible
```
3. Install ansible terraform provider as per [here](https://github.com/ansible/terraform-provider-ansible?tab=readme-ov-file)

### Setup Case Study Environment

1. Log into WSL
2. run: ```terraform plan   -var "do_token=${DO_PAT}"   -var "pvt_key=$HOME/.ssh/id_rsa"  ```
3. run: ```terraform apply   -var "do_token=${DO_PAT}"   -var "pvt_key=$HOME/.ssh/id_rsa```

### Destroy Case Study Environment
To remove the case study environment and prevent unwanted costs run the following steps:
1. Log into WSL
2. run: ```terraform apply  -destroy  -var "do_token=${DO_PAT}"   -var "pvt_key=$HOME/.ssh/id_rsa"```
