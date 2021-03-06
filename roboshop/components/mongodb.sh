#!bin/bash 

source components/common.sh

Print "Setting up Mongodb repo"

echo '[mongodb-org-4.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.2/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.2.asc' >/etc/yum.repos.d/mongodb.repo
Status_Check $?

Print "Installing Mongodb\t"
  yum install -y mongodb-org &>>/tmp/log
 Status_Check $?
 
 Print "Configuring Mongodb\t"
 sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
 Status_Check $?

Print "Starting Mongodb\t"
 systemctl enable mongod
 systemctl restart mongod
 Status_Check $?

Print "Downloading Mongodb schema"
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip"
Status_Check $?

cd /tmp
    Print "Extracting mongodb Archive"
 unzip -o mongodb.zip &>>/tmp/log
 Status_Check $?

 cd mongodb-main
   Print "Loading schema\t\t"
 mongo < catalogue.js &>>/tmp/log
 mongo < users.js  &>>/tmp/log
 Status_Check $?
 
 exit 0