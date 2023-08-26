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

yum install maven -y &>>$LOG_FILE
VALIDATE $? "Maven installation"

VALIDATE_ROBOSHOP=$(id roboshop)
if [ $? -ne 0 ]
then
    useradd roboshop &>>$LOG_FILE
    echo -e "$Y User added $N"
else
    echo -e "$Y User exists $N"
fi

VALIDATE_DIR=$(cd /app)
if [ $? -ne 0 ]
then
     mkdir /app &>>$LOG_FILE
     echo -e "$Y Directory creation is successful $N"
else
    echo -e "$Y Directory already exists $N"
fi

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip &>>$LOG_FILE
VALIDATE $? "copying Shipping.zip"

cd /app
unzip /tmp/shipping.zip &>>$LOG_FILE
VALIDATE $? "copying Shipping.zip"

cd /app
mvn clean package &>>$LOG_FILE
VALIDATE $? "copying Shipping.zip"

mv target/shipping-1.0.jar shipping.jar &>>$LOG_FILE
VALIDATE $? "copying Shipping.zip"

cp /home/centos/roboshop-shell-practice/shipping.service /etc/systemd/system/shipping.service &>>$LOG_FILE
VALIDATE $? "copying Shipping.zip"

systemctl daemon-reload &>>$LOG_FILE
VALIDATE $? "daemon-reload"

systemctl enable shipping &>>$LOG_FILE
VALIDATE $? "enable shipping"

systemctl start shipping &>>$LOG_FILE
VALIDATE $? "start shipping"

yum install mysql -y &>>$LOG_FILE
VALIDATE $? "install mysql"

#mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pRoboShop@1 < /app/schema/shipping.sql &>>$LOG_FILE
#VALIDATE $? "Connect to mysql"

#systemctl restart shipping &>>$LOG_FILE
#VALIDATE $? "restart shipping"