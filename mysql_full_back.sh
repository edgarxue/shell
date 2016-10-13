#!/bin/bash
#
# for: zabbix mysql DB
# by: edgar 
# 
#======================================================
# Make mysql full backup scripts
# Use this script must install xtrabackupex,ex: yum -y install percona-xtrabackup
#======================================================

source /etc/bashrc
source /etc/profile


#======================================================
# Set basic message for mysql
#======================================================

MySQL_ROOT=
MySQL_PASSWORD=
MySQL_HOST=********
MySQL_FULL_BACK_PATH=/data/mysql_full_back
DATE=$(date '+%Y-%m-%d')
TIME=$(date '+%H:%M:%S')
COMMAND=/usr/bin/innobackupex

#======================================================
cd

echo "======================================================" >> ${MySQL_FULL_BACK_PATH}/logs/MYSQL_FULL_BACKUP.log
echo "${DATE} ${TIME} : Begin to full backup !" >> ${MySQL_FULL_BACK_PATH}/logs/MYSQL_FULL_BACKUP.log

${COMMAND} --user=${MySQL_ROOT} --password=${MySQL_PASSWORD} ${MySQL_FULL_BACK_PATH} &> /dev/null 

 
[ "$?" == 0 ] && echo "${DATE} ${TIME} : OK: Mysql Full Backup succeed"          >> ${MySQL_FULL_BACK_PATH}/logs/MYSQL_FULL_BACKUP.log
[ "$?" != 0 ] && echo "${DATE} ${TIME} : Error: Mysql Full Backup not succeed"   >> ${MySQL_FULL_BACK_PATH}/logs/MYSQL_FULL_BACKUP.log

sleep 1

${COMMAND} --apply-log ${MySQL_FULL_BACK_PATH}/${DATE}_* &> /dev/null

[ "$?" == 0 ] && echo "${DATE} ${TIME} : OK: Already prepared for backup!"          >> ${MySQL_FULL_BACK_PATH}/logs/MYSQL_FULL_BACKUP.log
[ "$?" != 0 ] && echo "${DATE} ${TIME} : Error: Backup failed or Backup files not exists !"   >> ${MySQL_FULL_BACK_PATH}/logs/MYSQL_FULL_BACKUP.log

#echo "======================================================" >> ${MySQL_FULL_BACK_PATH}/logs/MYSQL_FULL_BACKUP.log

#======================================================
#Delete backup file what be make more than a week
#======================================================
cd ${MySQL_FULL_BACK_PATH}/
rm -rf $(date +%Y-%m-%d --date='7 days ago')_*

exit 0

