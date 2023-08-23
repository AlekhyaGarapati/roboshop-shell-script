#!/bin/bash

USER=$(id -u)
DATE=$(date +%F)
SCRIPT_NAME=$0
LOG_FILE=/tmp/$SCRIPT_NAME-$DATE.log
NEWUSER="roboshop"
NEW_DIR="/app"

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE_USER()
{ 
   if [ $USER -ne 0 ] 
   then
       echo  -e "$Y You should have sudo access to install cart $N"
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
CHECK_USER $NEWUSER

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> $LOG_FILE
VALIDATE $? "Adding nodejs repository"

yum install nodejs -y &>> $LOG_FILE
VALIDATE $? "Installig Nodejs"

id $NEWUSER

if [ $? -ne 0 ]
then 
    useradd roboshop &>> $LOG_FILE
VALIDATE $? "Adding user roboshop"
fi


mkdir /app &>> $LOG_FILE
VALIDATE $? "Creating app directory"

curl -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>> $LOG_FILE
VALIDATE $? "Downloading code"

cd /app 
echo -e "$Y current directory:$(pwd) $N"

unzip /tmp/cart.zip &>> $LOG_FILE
VALIDATE $? "Unzipping code to app directory"

echo -e "$Y current directory:$(pwd) $N"

npm install &>> $LOG_FILE
VALIDATE $? "Installing nodejs repositories"

cp home/centos/roboshop-shell-script/cart.service /etc/systemd/system/cart.service &>> $LOG_FILE
VALIDATE $? "Creation and copying cart service"

systemctl daemon-reload &>> $LOG_FILE
VALIDATE $? "daemon-reload"

systemctl enable cart &>> $LOG_FILE
VALIDATE $? "Enabling cart"

systemctl start cart &>> $LOG_FILE
VALIDATE $? "Starting cart"