#!bin/bash

Status_Check() {
  if [ $1 -eq 0 ]; then 
    echo -e "\e[32mCOMPLETED\e[0m"
  else 
    echo -e "\e[31mNOTCOMPLETED\e[0m"
    echo -e "\e[33m Refer Log file : &>>/tmp/log for more information\e[0m"
    
    exit 2
  fi 
}

Print() {
  echo -e "\n\t\t\e[36m----------------- $1 ----------------------\e[0m\n" &>>/tmp/log
  echo -n -e "$1 \t- "
}
if [ $SUI -ne 0 ]; then
    echo -e "\n\e[1;35mYou need root permission\e[0m\n"
    exit 1
    
    fi
    
    ADD_APP_USER() {
  Print "Adding RoboShop User\t"
  id roboshop &>>/tmp/log
  if [ $? -eq 0 ]; then
    echo "User already there, So Skipping" &>>/tmp/log
  else
    useradd roboshop &>>/tmp/log
  fi
  Status_Check $?
}

DOWNLOAD() {
  Print "Downloading ${COMPONENT} Content"
  curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>/tmp/log
  Status_Check $?
  Print "Extracting ${COMPONENT}\t"
  cd /home/roboshop
  rm -rf ${COMPONENT} && unzip -o /tmp/${COMPONENT}.zip &>>/tmp/log  && mv ${COMPONENT}-main ${COMPONENT}
  Status_Check $?
}

SystemdD_Setup() {
  Print "Update SystemD Service\t"
  sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e  's/MONGO_ENDPOINT/mongodb.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' -e 's/CARTENDPOINT/cart.roboshop.internal/' -e 's/DBHOST/mysql.roboshop.internal/' -e 's/CARTHOST/cart.roboshop.internal/' -e 's/USERHOST/user.roboshop.internal/' -e 's/AMQPHOST/rabbitmq.roboshop.internal/' /home/roboshop/${COMPONENT}/systemd.service
  Status_Check $?

  Print "Setup SystemD Service\t"
  mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service && systemctl daemon-reload && systemctl restart ${COMPONENT} &>>/tmp/log && systemctl enable ${COMPONENT} &>>/tmp/log
  Status_Check $?
}

NODEJS() {
  Print "Installing NodeJS\t"
  yum install nodejs make gcc-c++ -y &>>/tmp/log
  Status_Check $?
  ADD_APP_USER
  DOWNLOAD
  Print "Download NodeJS Dependencies"
  cd /home/roboshop/${COMPONENT}
  npm install --unsafe-perm &>>/tmp/log
  Status_Check $?
  chown roboshop:roboshop -R /home/roboshop
  SystemdD_Setup
}

JAVA() {
  Print "Installing Maven\t"
  yum install maven -y &>>/tmp/log
  Status_Check $?
  ADD_APP_USER
  DOWNLOAD
  cd /home/roboshop/shipping
  Print "Make Shipping Package\t"
  mvn clean package &>>/tmp/log
  Status_Check $?
  
  Print "Rename Shipping Package"
  mv target/shipping-1.0.jar shipping.jar &>>/tmp/log
  Status_Check $?
  chown roboshop:roboshop -R /home/roboshop
  SystemdD_Setup
}

PYTHON() {
  Print "Install Python3\t\t"
  yum install python36 gcc python3-devel -y &>>/tmp/log
  Status_Check $?

  ADD_APP_USER

  DOWNLOAD

  cd /home/roboshop/payment
  Print "Install Python Dependencies"
  pip3 install -r requirements.txt &>>/tmp/log
  Status_Check $?

  USERID=$(id -u roboshop)
  GROUPID=$(id -u roboshop)

  Print "Update RoboShop User in Config"
 sed -i -e "/uid/ c uid=${USERID}" -e "/gid/ c gid=${GROUPID}" /home/roboshop/payment/payment.ini &>>/tmp/log
  Status_Check $?

  SystemdD_Setup
}


 