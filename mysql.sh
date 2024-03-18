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

yum module disable mysql -y  &>>$LOGFILE

VALIDATE $? "disabling default mysql version"


cp /home/centos/roboshopshell/mysql.repo /etc/yum.repos.d/mysql.repo &>>$LOGFILE

VALIDATE $? "copying mysqlrepo"

yum install mysql-community-server -y &>>$LOGFILE

VALIDATE $? "installing mysqlserver"

systemctl enable mysqld &>>$LOGFILE

VALIDATE $? "enabling mysql"


systemctl start mysqld &>>$LOGFILE

VALIDATE $? "starting mysql"

mysql_secure_installation --set-root-pass RoboShop@1 &>>$LOGFILE

VALIDATE $? "setting up root password"


