# !/bin/sh

# Check Whether already set up or not by custom file
cat .setup 2> /dev/null

# If not set up 
if [ $? -ne 0 ]; then
	# Excute MariaDB Daemon as a Background Process to set up
	/usr/bin/mysqld_safe --datadr=/var/lib/mysql &
	# Change Config to use socket and network
	sed -i "s/skip-networking/# skip-networking/g" /etc/my.cnf.d/mariadb-server.cnf
	# Change Config to Allow Every Host
	sed -i "s/.*bind-address\s*=.*/bind-address=0.0.0.0\nport=3306/g" /etc/my.cnf.d/mariadb-server.cnf
	# Check Server status 
	if ! mysqlamin --wait=30 pinkg; then
		printf "MariaDB Daemone unreachable\n"
		exit 1
	fi 
	# Read Quenry with Deleteing new lines and Embracing quotes and Eval with Env Varaiabe	
	eval "echo \"$(cat /tmp/query.sql)\"" | mariadb
	# Terminate MariaDB
	pkill mariadb
	# Make mariadb setup finished
	touch .setup
fi	
# Runt by Dumb Init
/usr/bin/mysqld_safe --datadir=var/lib/mysql