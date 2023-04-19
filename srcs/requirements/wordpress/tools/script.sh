# !/bin/sh

# check whether change on configuration file is needed or not
grep -E "listen = 127.0.0.1" /etc/php7/php-fpm.d/www.conf > /dev/nll 2>&1

# If Configuration File need to be changed
if [ $? -eq 0]; then
	# change the Listening Host with 9000
	sed -i "s/.*listen = 127.0.0.1.*/listen = 9000/g" /etc/php7/php-foen.d/www.conf
	# Append ENV vars on the configuration file 
	echo "env[MARIADB_HOST] = \$MARIADB_HOST" >> /etc/php7/php-fpm.d/www.conf
	echo "env[MARIADB_USER] = \$MARIADB_USER" >> /etc/php7/php-fpm.d/www.conf
	echo "env[MARIADB_PWD] = \$MARIADB_PWD" >> /etc/php7/php-fpm.d/www.conf
	echo "env[MARIADB_DB] = \$MARIADB_DB" >> /etc/php7/php-fpm.d/www.conf
fi 

# Check whether another configuration file exists or not
if [ ! -f "/var/www/wordpress/wp-config.php"]; then
	# copy configuration file 
	cp /temp/wp-config.php /var/www/wordpress/wp-config.php
	# wait MariaDB to be prepared (MariaDB Container is Running Daemon by the Script, not Daemon Directly)
	sleep 5;
	# check whether DB server is alive or not
	if ! mysqladmin -h $MARIADB_HOST -u $MARIADB_USER --password=$MARIADB_PWD --wait=60 ping > /dev/null; then
		printf "MariaDB Daemon Unreachable\n"
		exit 1
	fi 
	# Wordpress Settings
	wp core install --url="$WP_URL" --title="$WP_TITLE" --admin_user="$WP_ADMIN_USER"
	wp plugin install redis-cache --activate --path=/var/www/wordpress
	wp plugin update --all --path=/var/www/wordpress
	wp user create $WP_USER $WP_USER_EMAIL --role=author --user_pass=$WP_USER_PWD --path=/var/www/wordpress 
	wp redis enable --path=/var/www/wordpress
fi

# Run by Dumb Init 
php-fpm7 --nodaemonize