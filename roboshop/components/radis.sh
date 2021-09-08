

#!bin/bash


source components/common.sh


Print "Install Yum Utils & Download Radis Repos"
 yum install epel-release yum-utils  yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y &>>/tmp/log
 Status_Check $?
 
 Print "Setup Radis Repos"
 yum-config-manager --enable remi &>>/tmp/log
Status_Check $?


Print "Install Radis"
yum install redis -y &>>/tmp/log
Status_Check $?

Print "Configure redis listen Address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf 
Status_Check $?

Print "Start Redis service"
systemctl enable redis &>>/tmp/log && systemctl start redis &>>/tmp/log
Status_Check $?
