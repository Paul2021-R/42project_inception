#!/bin/bash

service mariadb start 
# 마리아DB를 시작

echo "CREATE DATABASE IF NOT EXISTS wordpressDB ;" > db1.sql
echo "CREATE USER IF NOT EXISTS 'haryu'@'%' IDENTIFIED BY '0314haryu' ;" >> db1.sql
echo "GRANT ALL PRIVILEGES ON wordpressDB.* TO 'haryu'@'%' ;" >> db1.sql
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '0314' ;" >> db1.sql
echo "FLUSH PRIVILEGES;" >> db1.sql
# 마리아db 설정을 SQL문으로 작성한다. 

mysql < db1.sql
# 해당 sql 문을 MariaDB에 적용

kill $(cat /var/run/mysqld/mysqld.pid)
# MariaDB 를 끈다. 

mysqld
# 다시 시작시킨다. 