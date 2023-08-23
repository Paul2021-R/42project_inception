FROM debian:bullseye

RUN apt-get -y update && apt-get install -y nginx && apt-get install openssl dumb-init -y
RUN mkdir -p /var/www/html 
# -p 옵션으로 중간에 폴더 없으면 만들기
RUN openssl req -newkey rsa:4096 -days 365 -nodes -x509 \
 -subj "/C=KR/ST=Seoul/L=Seoul/O=42Seoul/OU=42Seoul/CN=haryu" \
 -out /etc/ssl/certs/haryu.42.fr.crt -keyout /etc/ssl/private/haryu.42.fr.key
# 키 생성 
# -x509 옵션은 OpenSSL에게 CSR을 대신해서 자기 서명된 인증서 발급을 명령한다. 
# -nodes 프라이빗 키의 암호화를 요청하지 않는 것으로, 좀더 취약하지만 들어갈 수 있는 키를 요청하는 옵션
# -days 유효 날짜를 특정짓는 용도
# -newkey 생성되어야 하는 프라이빗 키를 확인하는 용도, rsa:4096인자는 4096비트 길이의 RSA 키 요청을 하는 것이다. 
# -keyout 은 인증서 저장 공간을 가리킨다. 위치는 NGINX의 설정과 일치하게 해야함. 

COPY ./conf/default /etc/nginx/sites-available/
# 설정 파일의 이동

CMD ["nginx", "-g", "daemon off;"]
# 컨테이너 시작 시 NGINX 의 실행, 데콘모드 작동을 끄고 포그라운드에서 동작하게 만든다. 
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
# 컨테이너 시작시 dumb-init 초기화 프로세서로 시그널 처리를 향상 시킨다. 
# -- 는 옵션값. 