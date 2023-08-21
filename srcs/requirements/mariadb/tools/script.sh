#!/bin/bash

service mariadb start 

echo "CREATE DATABASE IF NOT EXISTS wordpressDB ;" > db1.sql
echo "CREATE USER IF NOT EXISTS 'haryu'@'%' IDENTIFIED BY '0314haryu' ;" >> db1.sql
echo "GRANT ALL PRIVILEGES ON wordpressDB.* TO 'haryu'@'%' ;" >> db1.sql
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '0314' ;" >> db1.sql
echo "FLUSH PRIVILEGES;" >> db1.sql

mysql < db1.sql

kill $(cat /var/run/mysqld/mysqld.pid)

mysqld
