

#!bin/bash


source components/common.sh


Print "Install Yum Utils & Download Radis Repos"
 yum install epel-release yum-utils  yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y &>>/tmp/log
 Status_Check $?
 
 Print "Setup Radis Repos\t\t\t"
 yum-config-manager --enable remi &>>/tmp/log
Status_Check $?


Print "Install Radis\t\t\t\t"
yum install redis -y &>>/tmp/log
Status_Check $?

Print "Configure Redis Listen Address\t\t\t"
if [ -f /etc/redis.conf ]; then
  sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf
fi
if [ -f /etc/redis/redis.conf ]; then
  sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf
fi
Status_Check $?

Print "Configure redis listen Address\t"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf 
Status_Check $?

Print "Start Redis service\t\t\"
systemctl enable redis &>>/tmp/log && systemctl start redis &>>/tmp/log
Status_Check $?
