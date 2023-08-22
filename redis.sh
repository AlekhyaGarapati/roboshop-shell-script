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
       echo -e "$R You should have sudo access to Install $N"
       exit 1
  fi
}

VALIDATE()
{
    if [ $1 -ne 0 ]
     then
        echo -e "$R $2 is Failed. Please Check Logfile. $N"
     else
        echo -e "$G $2 is Successful $N"
    fi
}

VALIDATE_USER $USER

yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>> $LOG_FILE
VALIDATE $? "rpm Installation "

yum module enable redis:remi-6.2 -y &>> $LOG_FILE
VALIDATE $? "6.2 Redis Module Enabling"

yum install redis -y &>> $LOG_FILE
VALIDATE $? "redis Installation"

sed -i s/127.0.0.1/0.0.0.0/ /etc/redis.conf &>> $LOG_FILE
VALIDATE $? "IP Updation in  /etc/redis.conf"

sed -i s/127.0.0.0/0.0.0.0/ /etc/redis/redis.conf &>> $LOG_FILE
VALIDATE $? "IP Updation in  /etc/redis/redis.conf"

systemctl enable redis &>> $LOG_FILE
VALIDATE $? "Enabling redis"

systemctl start redis &>> $LOG_FILE
VALIDATE $? "Starting redis"
