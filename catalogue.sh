
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

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip  &>>$LOGFILE

VALIDATE $? "Downloading catalouge artifact"

cd /app  &>>$LOGFILE

VALIDATE $? "Moving into app directory"

unzip /tmp/catalogue.zip &>>$LOGFILE
 
VALIDATE $? "Unziping catalouge"

npm install  &>>$LOGFILE

VALIDATE $? "installing dependencies"

cp /home/centos/roboshopshell/catalouge.service /etc/systemd/system/catalogue.service  &>>$LOGFILE

VALIDATE $? "copying catalouge.service"

systemctl daemon-reload  &>>$LOGFILE

VALIDATE $? "daemon-reload"

systemctl enable catalogue  &>>$LOGFILE

VALIDATE $? "enabling catalouge"

systemctl start catalogue  &>>$LOGFILE

VALIDATE $? "starting catalouge"

cp /home/centos/roboshopshell/mongo.repo  /etc/yum.repos.d/mongo.repo  &>>$LOGFILE

VALIDATE $? "copying mongo.repo"

yum install mongodb-org-shell -y  &>>$LOGFILE

VALIDATE $? "Installing mongo client"


mongo --host mongodb.joindevops.online </app/schema/catalogue.js  &>>$LOGFILE

VALIDATE $? "loading catalouge data into mongodb"