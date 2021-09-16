#!bin/bash


source components/common.sh


Print "Install ErLang\t"

  yum list installed | grep erlang &>>/tmp/log
  if [ $? -eq 0 ]; then
  
    echo "Package Already installed" &>>/tmp/log
  else
    yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm -y &>>/tmp/log
  fi
Status_Check $?

Print "Setup RabbitMQ Repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>/tmp/log
Status_Check $?

Print "Install RabbitMQ"
yum install rabbitmq-server -y &>>/tmp/log
Status_Check $?

Print "Start RabbitMQ\t"
systemctl enable rabbitmq-server  &>>/tmp/log  && systemctl start rabbitmq-server &>>/tmp/log
Status_Check $?

Print "Create App user"
rabbitmqctl list_users | grep roboshop &>>/tmp/log
if [ $? -ne 0 ]; then
  rabbitmqctl add_user roboshop roboshop123 &>>/tmp/log
fi
rabbitmqctl set_user_tags roboshop administrator &>>/tmp/log && rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>/tmp/log
Status_Check $?
