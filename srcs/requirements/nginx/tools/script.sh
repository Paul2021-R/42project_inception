# !/bin/sh

# Check whether configuration file exist or not
if [ ! -f "/etc/nginx/conf.d/default.conf" ]; then
	# copy configuration file
	cp /tmp/nginx.conf/ /etc/nginx/conf.d/default.conf
	# Make wordpress ready to run nginx 
	sleep 5;
fi

# Run By Dumb-init
nginx -g 'daemon off'