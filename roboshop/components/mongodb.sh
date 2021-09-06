#!bin/bash 

Status_Check() {
  if [ $1 -eq 0 ]; then 
    echo -e "\e[32mSUCCESS\e[0m"
  else 
    echo -e "\e[31mFAILURE\e[0m"
    exit 2
  fi 
}

Print() {
  echo -e "\n\t\t\e[36m----------------- $1 ----------------------\e[0m\n" &>>/tmp/log
  echo -n -e "$1 \t- "
}

Print "Setting up Mongodb repo"

echo '[mongodb-org-4.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.2/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.2.asc' >/etc/yum.repos.d/mongodb.repo
 status_check $?

Print "Installing Mongodb"
  yum install -y mongodb-org &>>/tmp/log
 status_check $?
 
 Print "Configuring Mongodb"
 sed -i -e 's/127.0.0.0/0.0.0.0/' /etc/mongod.conf
 status_check $?

Print "Starting Mongodb"
 systemctl enable mongod
 systemctl restart mongod
 status_check $?

Print "Downloading Mongodb schema"
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip"
status_check $?

cd /tmp
    Print "Extracting mongodb Archive"
 unzip -o mongodb.zip &>>/tmp/log
 status_check $?

 cd mongodb-main
   Print "Loading schema"
 mongo < catalogue.js &>>/tmp/log
 mongo < users.js  &>>/tmp/log
 status_check $?
 
 exit 0