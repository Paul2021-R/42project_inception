-- Reset Already Exsting Root User on the Host
DELETE FROM
	mysql.user
WHERE
	User = '$MARIADB_ADMIN_USER'
	AND Host NOT IN ('$HOST_NAME', '$HOST_IPV4', '$HOST_IPV6');

-- Set Password of Root User on MariaDB
SET 
	PASSWORD FOR '$MARIADB_ADMIN_USER'@'$HOST_NAME' = PASSWORD('$MARIADB_ADMIN_PWD');

-- Create WordPress Database
CREATE DATABASSE IF NOT EXISTS $MARIA_DB;

-- Create Another User for Wordpress 
CREATE USER '$MARIADB_USER'@'%' IDENTIFIED BY '$MARIA_PWD';

-- Grant Permissions
GRANT ALL PRIVILEGES ON $MARIA_DB.* TO '$MARIADB_USER'@'%' WITH GRANT OPTION;

-- Apply
FLUSH PRIVILEGES;