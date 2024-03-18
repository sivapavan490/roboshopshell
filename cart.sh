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

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOGFILE

VALIDATE $? "Setting uo NPM resource"

yum install nodejs -y  &>>$LOGFILE

VALIDATE $? "Installing nodejs"

useradd roboshop  &>>$LOGFILE


mkdir /app  &>>$LOGFILE

curl -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip  &>>$LOGFILE

VALIDATE $? "Downloading cart artifact"

cd /app  &>>$LOGFILE

VALIDATE $? "Moving into app directory"

unzip /tmp/cart.zip &>>$LOGFILE
 
VALIDATE $? "Unziping catalgue"

npm install  &>>$LOGFILE

VALIDATE $? "installing dependencies"

cp /home/centos/roboshopshell/cart.service /etc/systemd/system/cart.service  &>>$LOGFILE

VALIDATE $? "copying cart.service"

systemctl daemon-reload  &>>$LOGFILE

VALIDATE $? "daemon-reload"

systemctl enable cart  &>>$LOGFILE

VALIDATE $? "enabling cart"

systemctl start cart  &>>$LOGFILE

VALIDATE $? "starting cart"

