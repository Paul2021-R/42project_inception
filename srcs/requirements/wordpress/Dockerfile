FROM debian:bullseye

RUN apt-get update -y 
RUN apt-get install php-fpm php-mysql dumb-init -y
RUN apt-get install curl -y

COPY ./tools/script.sh /
COPY ./tools/wp-config.php /

EXPOSE 9000

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD [ "/script.sh" ]
