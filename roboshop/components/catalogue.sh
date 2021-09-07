#!bin/bash


source components/common.sh

Print "Installing NodeJS"

yum install nodejs make gcc-c++ -y &>>/tmp/log

Status_Check $?

Print "Adding Roboshop user"
id roboshop &>>/tmp/log

if [ $? -eq 0 ]; then
echo "User is already there so skipping " &>>/tmp/log
else 
 useradd roboshop &>>/tmp/log
 fi
 Status_Check $?
 
Print "Downloading Catalogue Content"
 curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip"
 
Status_Check $?

Print "Extracting Catalogue"
 cd /home/roboshop
 unzip -o /tmp/catalogue.zip &>>/tmp/log
 mv catalogue-main catalogue 
Status_Check $?
Print "Download NodeJS Dependancy"
 cd /home/roboshop/catalogue
 npm install --unsafe-perm &>>/tmp/log
 Status_Check $?
 
 chow roboshop:roboshop -R /home/roboshop
 
  # mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
# systemctl daemon-reload
# systemctl start catalogue
# systemctl enable catalogue