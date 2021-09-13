
#!bin/bash


source components/common.sh

Print "instal nginx\t\t"
 yum install nginx -y &>>/tmp/log
 Status_Check $?
 


Print "Downlaod Frontend Archive"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>/tmp/log

Status_Check $?

Print "Extract Frontend Archive"
rm -rf /usr/share/nginx/* && cd /usr/share/nginx && unzip -o /tmp/frontend.zip  &>>/tmp/log  && mv frontend-main/* .  &>>/tmp/log  &&   mv static html  &>>/tmp/log

Status_Check $?


Print "Copy Nginx Roboshop Config"

 mv localhost.conf /etc/nginx/default.d/roboshop.conf
 Status_Check $?
 
 Print "Update Nginx RoboShop Config"
 
sed -i -e '/catalogue/ s/localhost/catalogue.roboshop.internal/'  /etc/nginx/default.d/roboshop.conf  &>>/tmp/log
Status_Check $?

 
 Print "Restart Nginx Service\t"
 systemctl restart nginx &>>/tmp/log && systemctl enable nginx &>>/tmp/log
 
 Status_Check $?