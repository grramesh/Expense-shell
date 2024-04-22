#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log #It will log in tmp directory as .log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
B="\e[34m"

VALIDATE(){    
       if [ $1 -ne 0 ]
      then
         echo -e "$2..$R FAILURE $N"
         exit 1
      else
         echo -e "$2.. $G SUCCESS $N"
    fi 
}

if [ $USERID -ne 0 ]
then 
    echo "please run this script in root access"
    exit 1 # manually exit if error come.# 
else
echo "you are root user." 

fi

dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "Installing mysql server"

systemctl enable mysqld  &>>$LOGFILE
VALIDATE $? "enabling mysql"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "starting mysql"

# mysql -hdb.rishvihaan.store -uroot -pExpenseApp@1 -e 'show databases;'  to check whether password being set or not will engage this command and give echo $? if answer is 0 it is already being set else need to be excuted
# VALIDATE $? "setting root password"
# below code will be useful for checking idempotent nature

if [ $? -ne 0 ] 
 then 
    mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
    VALIDATE $? "setting root password"
 else 
    echo -e "Mysql root password is already set up...$Y SKIPPING $N"   
 fi
 