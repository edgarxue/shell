#!/bin/bash
#
# for : back up zabbix config
# by: edgar
#
#================================================================
source /etc/bashrc
source /etc/profile

#================================================================
# config mysql basic message

MySQL_USER=
MySQL_PASSWORD=
MySQL_HOST=
MySQL_PORT=3306
MySQL_DUMP_PATH=/data/zabbix_config_backup
MySQL_DATABASE_NAME=zabbix
DATE=$(date '+%Y-%m-%d')
TIME=$(date '+%H:%M:%S')

#================================================================
# Make sure backup dir exists

[ -d ${MySQL_DUMP_PATH} ] || mkdir ${MySQL_DUMP_PATH}
cd ${MySQL_DUMP_PATH}
[ -d logs    ] || mkdir logs
[ -d ${DATE} ] || mkdir ${DATE}
cd ${DATE}

#================================================================
#Begin work

TABLE_NAME_ALL=$(mysql -u${MySQL_USER} -p${MySQL_PASSWORD} -P${MySQL_PORT} -h${MySQL_HOST} ${MySQL_DATABASE_NAME} -e "show tables"|egrep -v "(Tables_in_zabbix|history*|trends*|acknowledges|alerts|auditlog|events|service_alarms)")
for TABLE_NAME in ${TABLE_NAME_ALL}
do
    mysqldump -u${MySQL_USER} -p${MySQL_PASSWORD} -P${MySQL_PORT} -h${MySQL_HOST} ${MySQL_DATABASE_NAME} ${TABLE_NAME} >${TABLE_NAME}.sql
    sleep 1
done


[ "$?" == 0 ] && echo "${DATE} ${TIME} : Backup zabbix succeed"     >> ${MySQL_DUMP_PATH}/logs/ZabbixMysqlDump.log
[ "$?" != 0 ] && echo "${DATE} ${TIME} : Backup zabbix not succeed" >> ${MySQL_DUMP_PATH}/logs/ZabbixMysqlDump.log


#================================================================
# rm back file more 7 days
cd ${MySQL_DUMP_PATH}/
rm -rf $(date +%Y-%m-%d --date='7 days ago')
exit 0
