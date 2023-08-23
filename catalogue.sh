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
       echo  -e "$Y You should have sudo access to install catalogue $N"
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

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> $LOG_FILE
VALIDATE $? "NodeJS repos setup"

yum install nodejs -y &>> $LOG_FILE
VALIDATE $? "nodejs Installation"

useradd roboshop &>> $LOG_FILE
$VALIDATE $? "adding roboshop user"


mkdir /app &>> $LOG_FILE
VALIDATE $? "Dir creation"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> LOG_FILE
VALIDATE $? "Downloading application code"

cd /app 
unzip /tmp/catalogue.zip &>> LOG_FILE 
VALIDATE $? "Unzipping application code"

cd /app 
npm install &>> $LOG_FILE
VALIDATE $? "Installing Dependencies"

cp catalogue.service /etc/systemd/system/catalogue.service &>> $LOG_FILE
VALIDATE $? "Adding catalogue service"

systemctl daemon-reload &>> $LOG_FILE
VALIDATE $? "daemon-reload"

systemctl enable catalogue &>> $LOG_FILE
VALIDATE $? "Enabling Catalogue"

systemctl start catalogue &>> $LOG_FILE
VALIDATE $? "Starting Catalogue"

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOG_FILE
VALIDATE $? "copying mongo repo to install client"

yum install mongodb-org-shell -y &>> $LOG_FILE
VALIDATE $? "Installing mongodb client"

mongo --host 172.31.46.58</app/schema/catalogue.js &>> $LOG_FILE
VALIDATE $? "Loading Schema"