# Task 2
Setup virtual machine with Debian. Using Ansible upload & run simple Python application with Flask.

### Folder description
Folder contains one subfolder with python script: flask-app/hello_world.py. This script will run a local webserver on 5000 port and output Hello world on request.
Also there is a playbook for Ansible to download repo & run Python script.

### Steps to check
- Clone repo on your machine with Ansible installed
- Setup Ansible inventory: https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html
- Run playbook: `ansible-playbook playbook.yml`
- Since the playbook contains pm2 for a background running of a web server, you can navigate to http://localhost:5000 from the virtual machine or the main one, if ports are exposed. 
