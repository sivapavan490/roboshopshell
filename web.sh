#!/bin/bash

DATE=$(date =%F)
LOGSDIR=/tmp
SRIPTNAME=$0
LOGFILE=$LOGDIR/$0-$DATE.log
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

if [$USERID -ne 0];
then
  echo -e "$R ERROR: please run this script as root acess : $N"
  exit 1
fi

VALIDATE(){
 
    if [$1 -ne 0];
    then
        echo -e " $2....$R FAILURE $N"
        exit 1
    else
        echo -e "$2....$R SCUESS $N"
    fi

}

yum install nginx -y &>>$LOGFILE 

VALIDATE $? "INSTALLING NGINX "

systemctl enable nginx  &>>$LOGFILE

VALIDATE $? "ENABLING NGINX"

systemctl start nginx  &>>$LOGFILE

VALIDATE $? "STARTING NGINX "

rm -rf /usr/share/nginx/html/*  &>>$LOGFILE

VALIDATE $? "REMOVING THE OLD HTML CONTENT "

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip  &>>$LOGFILE

VALIDATE $? "DOWNLOADING THE FRONTEND CONTENT"

cd /usr/share/nginx/html  &>>$LOGFILE

VALIDATE $? "CHANGING THE DIRECTORY"

unzip /tmp/web.zip  &>>$LOGFILE

VALIDATE $? "UNZIPPING THE FRONTEND CONTENT"

cp /home/centos/roboshop.conf /etc/nginx/default.d/roboshop.conf  &>>$LOGFILE

VALIDATE $? "COPYING ROBOSHOP CONFIG"

systemctl restart nginx  &>>$LOGFILE

VALIDATE $? "RESTART NGINX"