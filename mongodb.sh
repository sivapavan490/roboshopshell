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

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "copied mongo.repo into yum.repos.d"

yum install mongodb-org -y &>> $LOGFILE

VALIDATE $? "installing mongod"

systemctl enable mongod &>> $LOGFILE

VALIDATE $? "enabling mongodb"

systemctl start mongod &>> $LOGFILE

VALIDATE $? "starting mongodb"

sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>> $LOGFILE

VALIDATE $? "edited mongodb ip"

systemctl restart mongod &>> $LOGFILE

VALIDATE $? "restarting mongodb" 