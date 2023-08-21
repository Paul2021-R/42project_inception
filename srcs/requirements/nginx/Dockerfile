FROM debian:bullseye

RUN apt-get -y update && apt-get install -y nginx && apt-get install openssl dumb-init -y
RUN mkdir -p /var/www/html
RUN openssl req -newkey rsa:4096 -days 365 -nodes -x509 \
 -subj "/C=KR/ST=Seoul/L=Seoul/O=42Seoul/OU=42Seoul/CN=haryu" \
 -out /etc/ssl/certs/haryu.42.fr.crt -keyout /etc/ssl/private/haryu.42.fr.key
COPY ./conf/default /etc/nginx/sites-available/

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["nginx", "-g", "daemon off;"]
