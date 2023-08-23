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

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOG_FILE
VALIDATE $? "Node js Setup"

yum install nodejs -y &>>$LOG_FILE
VALIDATE $? "Installation of nodejs"

VALIDATE_ROBOSHOP=$(id roboshop) &>>LOG_FILE

if [ $? -ne  0 ]
then
    useradd roboshop  &>>$LOG_FILE
    VALIDATE $? "User roboshop addded"
else 
   echo -e "$Y roboshop user already exists, please proceed $N"
fi

VALIDATE_DIR=$(cd /app) &>>$LOG_FILE

if [ $? -ne 0 ]
then
     mkdir /app  &>>$LOG_FILE
     VALIDATE $? "/app Directory creation"
else
    echo -e "$Y Directory already exist, please proceed $N"
fi

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip  &>>$LOG_FILE
VALIDATE $? "Files Copied"

cd /app  &>>$LOG_FILE
echo -e " $Y $(pwd) $N"

unzip /tmp/user.zip  &>>$LOG_FILE
VALIDATE $? "Unzipping user"

cd /app  &>>$LOG_FILE
echo -e " $Y $(pwd) $N"

npm install  &>>$LOG_FILE
VALIDATE $? "Dependencies installation"

cp /home/centos/roboshop-shell-script/user.service /etc/systemd/system/user.service &>>$LOG_FILE
VALIDATE $? "Creation of user service"

systemctl daemon-reload &>>$LOG_FILE
VALIDATE $? "daemon-reload"

systemctl enable user  &>>$LOG_FILE
VALIDATE $? "enabling user"

systemctl start user &>>$LOG_FILE
VALIDATE $? "Starting User"

cp /home/centos/roboshop-shell-script/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOG_FILE
VALIDATE $? "Copiying mongo repo"

yum install mongodb-org-shell -y &>>$LOG_FILE
VALIDATE $? "Installation of Mongo Client"

mongo --host 3.93.71.175</app/schema/user.js &>>$LOG_FILE
VALIDATE $? "Loading Schema"