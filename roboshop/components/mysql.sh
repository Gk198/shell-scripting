
#!bin/bash


source components/common.sh

Print "Setup MySQL Repo\t\t"

 echo '[mysql57-community]
name=MySQL 5.7 Community Server
baseurl=http://repo.mysql.com/yum/mysql-5.7-community/el/7/$basearch/
enabled=1
gpgcheck=0' > /etc/yum.repos.d/mysql.repo

SystemdD_Setup $?

Print "Install MySQL Service"
 yum remove mariadb-libs -y &>>/tmp/log && yum install mysql-community-server -y &>>/tmp/log
 Status_Check $?

Print "Start MySQL service"
systemctl enable mysqld &>>/tmp/log && systemctl start mysqld &>>/tmp/log
Status_Check $?

DEFAULT_PASSWORD=$(grep 'A temporary password' /var/log/mysqld.log | awk '{print $NF}')

Print "Reset Default Password\t\t"
echo 'show databases' | mysql -uroot -pRoboShop@1 &>>/tmp/log
if [ $? -eq 0 ]; then
  echo "Root Password is already set" &>>/tmp/log
else
  echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'RoboShop@1';" >/tmp/reset.sql
  mysql --connect-expired-password -u root -p"${DEFAULT_PASSWORD}" </tmp/reset.sql &>>/tmp/log
fi
Status_Check $?
Print "Uninstall Password Validate Plugin"
echo 'show plugins;' | mysql -u root -p"RoboShop@1" 2>/dev/null | grep -i validate_password &>>/tmp/log
if [ $? -eq 0 ]; then
  echo "uninstall plugin validate_password;" >/tmp/pass.sql
  mysql -u root -p"RoboShop@1" </tmp/pass.sql &>>/tmp/log
else
  echo "Password plugin is already uninstalled" &>>/tmp/log
fi
Status_Check $?

Print "Download the Schema\t\t"
curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip" &>>/tmp/log
Status_Check $?

Print "Extract Schema File\t\t"
cd /tmp && unzip -o  mysql.zip &>>/tmp/log
Status_Check $?

Print "Load Schema\t\t\t"
cd mysql-main
mysql -u root -pRoboShop@1 <shipping.sql &>>/tmp/log
Status_Check $?
