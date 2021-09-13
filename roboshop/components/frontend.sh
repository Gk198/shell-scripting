
#!bin/bash


source components/common.sh

Print "instal nginx"
 yum install nginx -y &>>/tmp/log
 Status_Check $?
 
# systemctl enable nginx  
# systemctl start nginx 

Print "Downlaod Frontend Archive"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>/tmp/log

Status_Check $?

Print "Extract Frontend Archive"
rm -rf  /usr/share/nginx/html  && cd /usr/share/nginx && unzip -o /tmp/frontend.zip &>>/tmp/log && mv frontend-main/* . &>>/tmp/log && mv static/* . &>>/tmp/log

Status_Check $?


Print "Update Nginx Roboshop Config"

 mv localhost.conf /etc/nginx/default.d/roboshop.conf
 Status_Check $?
 
 Print "Restart Nginx Service"

 systemctl restart nginx &>>/tmp/log && systemctl enable nginx &>>/tmp/log
 Status_Check $?