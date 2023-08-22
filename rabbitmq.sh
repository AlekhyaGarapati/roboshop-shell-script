#!/bin/bash

USER=$(id -u)
DATE=$(date +%F)
SCRIPT_NAME=$0
LOG_FILE=/tmp/$SCRIPT_NAME-$DATE.log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE_USER()
{ 
   if [ $USER -ne 0 ] 
   then
       echo  -e "$Y You should have sudo access to install rabbitmq $N"
       exit 1
    fi
}

VALIDATE()
{
    if [ $1 -ne 0 ]
    then
        echo -e "$R $2 is failed . Please see log file $N"
    else 
        echo -e "$G $2 is Successfull $N"
    fi
} 

VALIDATE_USER $USER

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash
VALIDATE $? "Configuring yum repos from the script provided by vendor" 

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash
VALIDATE $? "Configuring yum repos for rabbitmq"

yum install rabbitmq-server -y 
VALIDATE $? "Installation of rabbitmq "

systemctl enable rabbitmq-server 
VALIDATE $? "Enabling rabbitmq server"

rabbitmqctl add_user roboshop roboshop123
VALIDATE $? "Adding user and setting up password"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
VALIDATE $? "Setting permissions"