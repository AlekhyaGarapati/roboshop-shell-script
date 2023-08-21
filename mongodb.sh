#!/bin/bash

DATE=$(date +%F)
SCRIPT_NAME=$0
LOG_DIR =/tmp
LOG_FILE=$LOG_DIR/$SCRIPT_NAME-$DATE.log
USER=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE()
{
    if [ $1 -ne 0 ]
    then 
        echo "$G $2 is Successful $N"
    else
        echo "$R $2 is Failed $N"
    fi
}

if [ $USER -ne 0]
    then 
        echo "$R You need sudo access to install $N"
        exit 1
fi

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOG_FILE
VALIDATE $? "Copying Mongo repo file to /etc/yum.repos.d directory "

yum install mongodb -y
VALIDATE $? "Installing Mongodb"

systemctl enable mongod
VALIDATE $? "Enabling Mongodb"
systemctl start mongod
VALIDATE $? "Starting Mongodb"
sed -i s/127.0.0.1/0.0.0.0/ /etc/mongod.conf
VALIDATE $? "Changing IP Address form local host to ip4"
systemctl restart mongod
VALIDATE $? "Restarting Mongodb"
