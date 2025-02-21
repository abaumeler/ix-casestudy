# Inventx Case Study Environment

## Setup
### Pre-Reqs
- WSL with Ubuntu set up on managed device
- Digital Ocean Account with payment set up
- Digital Ocean access token, save as $DO_PAT in WSL
- SSH key-pair generated on the WSL
- Public key added to Digital Ocean account

### Setup WSL 
1. Install terraform to WSL as per [here](https://www.digitalocean.com/community/tutorials/how-to-use-terraform-with-digitalocean) and set the DO_PAT env varible to your Digtal Ocean access token
2. Install ansible to WSL as  per [here](https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html#installing-ansible-on-ubuntu), in short: 
```
$ sudo apt update
$ sudo apt install software-properties-common
$ sudo add-apt-repository --yes --update ppa:ansible/ansible
$ sudo apt install ansible
```
3. Create an .ansible.cfg file in your wsl home
```
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
4. Install ansible terraform provider as per [here](https://github.com/ansible/terraform-provider-ansible?tab=readme-ov-file)
5. Install the RealVNC viewer. Download the .deb package from [here](https://www.realvnc.com/de/connect/download/viewer/linux/), Install the .deb package with ```sudo dpkg -i <package> ```

### Setup Case Study Environment

1. Log into WSL
2. run: ```terraform plan   -var "do_token=${DO_PAT}"   -var "pvt_key=$HOME/.ssh/id_rsa"  -var "pub_key=$HOME/.ssh/id_rsa.pub" ```
3. run: ```terraform apply   -var "do_token=${DO_PAT}"   -var "pvt_key=$HOME/.ssh/id_rsa -var "pub_key=$HOME/.ssh/id_rsa.pub" ``` this will create all machines and add the required entries to the ansible inventory file


... run ansible playbooks as needed to deploy the desired study cases


#### Steps to do manually
- Copy content of the used private key to ansible/ssh-keys/id_rsa
-  run ```ansible-playbook client-setup.yml -i inventory.yml```
- log into the client machine as root to start the autoconfiguration and note the credentials for the VNC connection: 
```
Ubuntu-desktop is now installed and configured. Enjoy it!

----------------------------------------------------------------------------
Your VNC password is "/70smkix". To update it you can run:
x11vnc -storepasswd %NEW_PASSWORD% /home/user/.vnc/passwd
Using XServer from root account is not recommended, so user "user" is created with password "uGLqcNnD"
To change user's password execute 'passwd user'
Raw generated authentication data is stored in '/root/.digitalocean_passwords'
----------------------------------------------------------------------------
Ubuntu-Desktop is starting, please wait about 2-3 minutes until console is unblocked
Adding user `user' ...
Adding new group `user' (1000) ...
Adding new user `user' (1000) with group `user' ...
Creating home directory `/home/user' ...
Copying files from `/etc/skel' ...
stored passwd in file: /home/user/.vnc/passwd
Created symlink /etc/systemd/system/graphical.target.wants/x11vnc.service → /lib/systemd/system/x11vnc.service.
Synchronizing state of sddm.service with SysV service script with /lib/systemd/systemd-sysv-install.
Executing: /lib/systemd/systemd-sysv-install enable sddm
```
- Start the vncviewer in WSL by using the command ```vncviewer```. Alternatively any other VNC client can be used by the candidate
- Log into the client ```client-ip:5900 ``` and complete the setup of the desktop environment
- Run ansible playbooks to deploy the desired study cases
- provide candidate with the connection & case details 

### Destroy Case Study Environment
To remove the case study environment and prevent unwanted costs run the following steps:
1. Log into WSL
2. run: ```terraform apply  -destroy  -var "do_token=${DO_PAT}"   -var "pvt_key=$HOME/.ssh/id_rsa" -var "pub_key=$HOME/.ssh/id_rsa.pub```
