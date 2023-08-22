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
        echo -e "$Y You need sudo access to Install MySql $N"
    fi
}

VALIDATE()
{
    if [ $1 -ne 0 ]
    then
       echo -e "$R $2 is Failed. Please check in log file $N"
    else
       echo -e "$G $2 is Successful $N"
    fi
}

VALIDATE_USER $USER

yum module disable mysql -y &>> $LOG_FILE
VALIDATE $? "Disabling mysql default version"

cp mysql.repo /etc/yum.repos.d/mysql.repo &>> $LOG_FILE
VALIDATE $? "Adding mysql.repo to /etc/yum.repos.d"

yum install mysql-community-server -y &>> $LOG_FILE
VALIDATE $? "Installation of MySQL"

systemctl enable mysqld &>> $LOG_FILE
VALIDATE $? "Enabling Mysqld"

systemctl start mysqld &>> $LOG_FILE
VALIDATE $? "Starting mysqld"

mysql_secure_installation --set-root-pass RoboShop@1 &>> $LOG_FILE
VALIDATE $? "Updating default root password"

mysql -uroot -pRoboShop@1 &>> $LOG_FILE
VALIDATE $? "Setting up user and new password"








