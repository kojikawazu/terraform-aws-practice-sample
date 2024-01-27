#!/bin/bash

sudo yum -y update

# NGINX
nginx -v

if [ $? -ne 0 ]; then
  sudo yum -y install nginx
fi

sudo sed -i 's/80/3000/g' /etc/nginx/nginx.conf

sudo systemctl start nginx
sudo systemctl enable nginx
sudo systemctl restart nginx

# DB Client
sudo yum -y install mariadb105
