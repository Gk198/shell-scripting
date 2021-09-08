#!bin/bash


source components/common.sh

Print "Installing NodeJS\t"

yum install nodejs make gcc-c++ -y &>>/tmp/log

Status_Check $?

Print "Adding Roboshop user\t"
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

Print "Extracting Catalogue\t"
 cd /home/roboshop
 rm -rf catalogue && unzip -o /tmp/catalogue.zip &>>/tmp/log && mv catalogue-main catalogue 
Status_Check $?
Print "Download NodeJS Dependancy"
 cd /home/roboshop/catalogue
 npm install --unsafe-perm &>>/tmp/log
 Status_Check $?
 chown roboshop:roboshop -R /home/roboshop
 
 Print "update systemd service\t"
 sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/roboshop/catalogue/systemd.service
 Status_Check $?
 
 Print "Setup systemd service\t"
 mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service && systemctl daemon-reload && systemctl restart catalogue &>>/tmp/log && systemctl enable catalogue &>>/tmp/log
 
 Status_Check $?