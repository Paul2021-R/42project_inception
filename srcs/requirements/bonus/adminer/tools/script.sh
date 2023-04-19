# !/bin/sh

# Check whether change on configuration file is needed or not 
grep -E "listen = 127.0.0.1" /etc/php7/php-fpm.d/www.conf > /dev/null 2>&1

# If configuration file needs to be changed
if [ $? -eq 0 ]; then
	# Change the Listening Host with 8000 port
	sed -i "s/.*listen = 127.0.0.1.*/listen = 8000/g" /etc/php7/php-fpm.d/www.conf
fi

# Check index.php file is exist or not
if [ ! -f "/var/www/wordpress/adminer/index.php" ]; then
	# Create the directory on wordpress to serve adminer 
	mkdir -p /var/www/wordpress/adminer 
	# Download a sole adminer page
	curl -s -L https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1-mysql-en.php --output /var/www/wordpress/adminer/index.php
fi

# Run by Dumb Init
php-fpm7 --nodaemonize