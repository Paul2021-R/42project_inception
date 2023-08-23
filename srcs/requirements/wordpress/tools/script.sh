#!/bin/bash

# mount 위치에 폴더 작성하기
mkdir -p /var/www/html
cd /var/www/html

# 행여 기존 내용 있다면 삭제 
rm -rf *

# wp-cli.phar 다운로드하여서 설치하기 
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar 
chmod +x wp-cli.phar 
mv wp-cli.phar /usr/bin/wp

# wp 명령어 사용 가능해짐. 이제, core 를 다운 받으며, 이때 설정을 넣어둠
wp core download --locale=ko_KR --allow-root
#샘플 설정 삭제
rm /var/www/html/wp-config-sample.php
# 지정해야 하는 설정 파일의 위치를 변경
mv /wp-config.php /var/www/html/wp-config.php

# wordpress 설치 과정 
wp core install --url=${DOMAIN_URL} --title=${TITLE} --admin_user=${ADMIN_ROOT} --admin_password=${ADMIN_ROOT_PW} --admin_email=${ADMIN_ROOT_EMAIL} --skip-email --allow-root
wp user create ${WP_USER} ${WP_EMAIL} --role=author --user_pass=${WP_PASSWORD} --allow-root
wp plugin update --all --allow-root

# PHP-FPM 설정 변경 
sed -i 's/listen = \/run\/php\/php7.4-fpm.sock/listen = 0.0.0.0:9000/g' /etc/php/7.4/fpm/pool.d/www.conf
mkdir /run/php

# PHP-FPM 서버 실행, -F 옵션을 주면 background 가 아닌 foreground 로 실행시킨다. 
/usr/sbin/php-fpm7.4 -F
