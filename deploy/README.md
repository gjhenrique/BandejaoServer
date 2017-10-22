Configuration management and automation of provisioning and deploy for [BandejaoServer](https://github.com/gjhenrique/EasyMenuServer)

Basically, we install software with Ansible and deploy our application with Capistrano

## Ansible
Installs the following software
* Rbenv
* Monit
* Rubinius
* Nginx

## Capistrano
* Database creation, migration and loading of seed data
* Nginx setup and configuration file
* Precompile assets 
* Puma setup
* Whenever cron jobs

## Staging environment with Vagrant
```
    vagrant box add debian-jessie https://github.com/holms/vagrant-jessie-box/releases/download/Jessie-v0.1/Debian-jessie-amd64-netboot.box
    vagrant up
    # Ansible to install the required dependencies libraries and applications
    vagrant provision
    # Deploy the application
    cap staging deploy -t
    # Visit localhost:8080 to check the application
```
