
#!bin/bash


source components/common.sh

Print "Setup MySQL Repo"
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

exit


Now a default root password will be generated and given in the log file.
# grep temp /var/log/mysqld.log

Next, We need to change the default root password in order to start using the database service.
# mysql_secure_installation

You can check the new password working or not using the following command.

# mysql -u root -p

Run the following SQL commands to remove the password policy.
> uninstall plugin validate_password;
Setup Needed for Application.
As per the architecture diagram, MySQL is needed by

Shipping Service
So we need to load that schema into the database, So those applications will detect them and run accordingly.

To download schema, Use the following command

# curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip"
Load the schema for Services.

# cd /tmp
# unzip mysql.zip
# cd mysql-main
# mysql -u root -pRoboShop@1 <shipping.sql