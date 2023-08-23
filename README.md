# 42project_inception
# Inception_42 

이 인셉션 프로젝트에 대한 완벽가이드는 도커 컨테이너의 정의와, 무얼 위해 그리고 무엇 때문에 사용하는지를 배우며, 어떻게 도커 이미지를 사용하며, 자신만의 도커 이미지를 스크래치 빌드가 가능한지를 배운다. 

## 컨테이너란 무엇인가?

컨테이너란 코드를 감싼, 그리고 의존성을 감싼 앱 레이어의 추상적 개념을 말한다. 다수의 컨테이너들은 동일한 기기에서 작동할 수 있으며, OS 커널 등의 다른 자원들을 다른 컨테이너들과 공유한다. 각 동작하는 컨테이너들은 구분된 프로세스로 존재하게 된다. 컨테이너들은 가상 머신(VM)에 비하여 더 적은 공간을 차지하며, 더 많은 어플리케이션들을 처리하거나, 가상 머신 그리고 운영체제보다 더 적게 필요로 한다. (일반적으로 컨테이너 이미지만 보면 수 MB 정도의 사이즈를 가진다. )

## 가상 머신이란 무엇인가?

가상 머신이란 물리적인 하드웨어의 하나의 서버를 튜닝하여 다수의 서버로 만들어내는 추상 개념이다. hypervisor는 다중의 가상머신이 하나의 머신에서 동작이 가능하게 도와준다. 각 가상 머신들은 온전한 운영체제 시스템을 포함하며, 어플리케이션 필요하다면 바이너리나, 라이브러리를 모두 포함하고 있기에 수십 GB를 점유하고 있으며, 부트 하는 부분에서도 느린 편이다. 

## 왜 도커이며 풀어야 하는 문제는 무엇인가?

> 자, 도커가 도입되기 이전 시대를 생각해보자

테스터, 개발자 등이 존재하고, 이들은 코드를 갖고 있으며, 자신들의 시스템 상에서 완벽하게 동작하는 것을 보았다. 하지만 테스터들이 그들의 머신에서 이 코드들에 테스트를 했을 때, 동작하지 않는다. 이에 대한 이유는 정말 많을 것이다. 몇 가지 의존성 문제가 우선 풀려야 한다던가, 코드가 적절하게 돌아가기 위한 몇가지 환경 변수들의 설정이 추가 되어야 한다던지.. 이런 문제들에 대해서 어떻게 풀 수 있겠는가? 

### 어떤 지점에서 도커가 자리 잡게 되었을까?

여기서 동시에 가상 머신 대비로 도커가 가지는 장점에 대해 스스로 생각해보자. 물론 도커가 가지는 단점도 정말 많고, 그렇기 때문에 도커와 가상 머신 사이의 차이점에 대해 살펴봐야한다. 

| Virtual Machine                                | Docker                                                  |
| ---------------------------------------------- | ------------------------------------------------------- |
| 많은 메모리를 차지한다                         | 더 적은 메모를 차지한다                                 |
| 기동하는데 오랜 시간이 걸린다.                 | 당신이 사용하는 커널을 그대로 활용하기에, 부팅이 빠르다 |
| 확장이 어렵다                                  | 확장이 매우 용이하다                                    |
| 효율성이 낮다                                  | 효율성이 매우 좋다                                      |
| VM들 사이에서 볼륨 저장 공간이 공유되지 않는다 | 호스트, 컨테이너들 사이에서 공유가 가능하다             |

![](01_42Seoul/Projects/inception/src/Pasted%20image%2020230730160358.png)
- Infrastructure : PC를 구성하는 물리적 컴포넌트들
- Host OS : 컴퓨터가 동작 하고 있는 OS
- Docker Engine : 도커 컴포넌트나 서비스들을 사용하는 컨테이너를 돌리거나, 빌드하기 위한 host 머신에 설치된 기반 엔진.
- App : 다른 컨테이너들과 독립적이게 가동되는 컨테이너들,

# 도커 엔진이 어떻게 동작하는지 더 자세히 알아봅시다. 

![](01_42Seoul/Projects/inception/src/Pasted%20image%2020230730162118.png)

도커 엔진은 도커의 컴포넌트의 코어이다. 애플리케이션과 해당 종속성을 컨테이너라고 하는 단일 패키지로 묶는 경량 런타임 및 패키징 도구이다. 도커 엔진은 도커 데몬을 포함하고 있으며, 도커 데몬이란 도커 컨테이너와 도커 클라이언트를 관리하는 백그라운드 프로세스를 말하며, 도커 클라이언트란 CLI 툴이며, 도커 데몬을 가지고 당신이 도커와 상호작용하는 것을 도와주는 툴이다. 

## 도커 엔진은 다음과 같이 동작한다. 

1. Dockerfile을 작성한다. 이는 텍스트 파일로, 도커 이미지를 빌드하기 위한 명령어를 포함하는 파일이다. `도커 이미지`는 가볍고, 스탠드얼론이고, 어플리케이션 코드, 라이브러리, 의존성, 런타임등을 포함하는 소프트웨어의 조각들을 돌리기 위해 필요한 모든 것을 포함한 실행 가능한 패키지라고 보면 된다. 
2. 이제 도커 클라이언트를 사용해서 도커 이미지를 빌드한다. 이때 `docker build` 라는 커멘드를 사용하며, Dockerfile의 구체적인 위치를 기재하여 실행하면 된다. 도커 데몬은 Dockerfile 안의 명령들을 읽은 뒤, 이미지의 빌드를 시작한다. 
3. 일단 이미지가 빌드가 마무리 되면, `docker run` 커맨드를 사용함으로써 이미들을 컨테이너로써 도커 클라이언트가 실행하도록 할 수 있다. Docker daemon 은 이미지 안에서 컨테이너를 생성하고, 컨테이너 안에 어플리케이션을 실행한다. 
4. Docker engine은 보안, 독립 환경을 어플리케이션의 실행에서 제공하며, CPU, 메모리, 저장소 등을 컨테이너를 위해 리소스 관리 역할등을 진행한다. 
5. Docker client는 시스템 상의 동작 중인 컨테이너들을 보고, 멈추거나 관리하기 위해 사용된다. Docker Client를 사용하면 도커 허브와 같은 저장소에 도커 이미지를 레지스트리 하여 클라이언트들에게 전달이 가능하다. 

# 도커를 이해했다면 도커파일과 도커 컴포즈 파일이 어떻게 동작하는지 이해해봅시다.

- Dockerfile은 Docker image를 빌드하기 위한 명령어들을 답고 있는 텍스트 파일이다. Dockerfile은 사용할 기반 이미지, 설치해야할 의존성, 소프트웨어와 또 다른 설정들 혹은 어플리케이션을 실행하기 위한 환결 설정에 필요한 스크립트 등으로 구성되어 있다. 
- Docker Compose 파일은 YAML 파일로, 어떻게 다수의 도커 컨테이너들이 설정되며 실행되어야 하는지를 정의하는 파일이다. 해당 파일을 통해 어플리케이션을 완성하고, 서비스를 정의하며, 그 뒤엔 단순한 커맨드들로 컨테이너들의 시작과 종료를 조작하는 것을 정의해준다. 

- 그렇다면 Dockerfile과 Docker Compose의 차이는 무엇인가?
	1. 목적 : Dockerfile은 단일 도커 이미지를 빌드하기 위해 사용되며, Docker Compose 파일은 다중 컨테이너를 단일 어플리케이션으로 정의하고, 실행하는데 사용된다. 
	2. 포맷 : Dockerfile은 순수한 text 파일로 구체적인 포맷과 syntax를 가진다. 이에 비해 Docker Compose는 YAML로 쓰여진다.
	3. 스코프(범위) : Dockerfile은 단일 이미지 빌딩에 집중한다. Docker Compose는 단일 어플리케이셔으로 다중 컨테이너를 정의하고 실행시키는데 집중한다. 
	4. 명령어 : Dockerfile은 특정한 명령어를 사용하고, 예로 `FROM`, `RUN`, `CMD` 등이 있으며, 이미지 빌드를 위한 명령어들이 지정되어 있다. Docker Compose 파일의 경우 다른 커맨드를 사용하는데, 예를 들어 `services`, `volumes`, `networks` 등으로 컨테이너들을 정의하며, 어떻게 설정되고 실행되는지가 정의되어져 있다. 
- 몇가지 위에서 언급한 몇가지 예시의 설명이다.
	1. `FROM` : 도커 이미지를 만들기 시작을 위한 명령어이며, Docker 이미지 빌드를 위한 첫 시작 부분이다. 기반 이미지는 이미지를 위한 바탕 레이어를 제공하며, 당신의 구체적 니즈를 위해 이미지를 커스터마이즈 하는데 추가적인 탑 레이어를 추가할 수 있다. 
	2. `RUN` : Dockerfile에서 컨테이너의 터미널 상에서 명령어를 실행시키기 위해 사용되는 커맨드이다. 전형적으로 어플리케이션에 의해 필요시 되는 소프트웨어 혹은 라이브러리를 설치하기 위해 사용된다. 
	3. `CMD` : Dockerfile 상에 이미지에서 컨테이너가 시작 될 때, 실행해야하는 기본 커맨드를 지정하기 위하여 사용되는 명령어이다. 주 커맨드가 컨테이너상에서 가장 먼저 시작해야할 때 사용된다. 
	4. `services` : Docker Compose 파일에서 어플리케이션에 대해 확실하게 서비스를 지정하는데 사용되는 키이다. 서비스는 구체적인 어플리케이션 혹은 어플리케이션의 컴포넌트를 돌리고 있는 컨테이너를 의미한다. 
	5. `volumes` : 어플리케이션을 위한 영구 저장소를 지정하기 위해 사용되는 Docker Compose 파일의 키 명령어. 볼륨은 컨테이너에 붙어있는 스토리지의 일부이며, 컨테이너가 멈추거나 지워지더라도, 여전히 존재해야 하며, 데이터를 저장하는데 사용된다. 
	6. `networks` : 다른 것들과 커뮤니케이션이 되게 만들어주거나, 컨테이너들 사이에 연결을 위해 가상의 네트워크를 정의 내려주는 핵심 명령어다. 

## 도커 상에서 가장 많이 사용되는 명령어는 무엇일까?

1. **`docker build`** : Dockerfile에서 도커 이미지를 빌드하기 위해 사용된다.
2. **`docker run`** : 도커 이미지 상에서 기반이 된 컨테이너를 실행하기 위해 사용된다. 
3. **`docker pull`** : Docker Hub와 같은 곳에서 등록된 도커 이미지를 pull 할 때 사용 한다.
4. **`docker push`** : 도커 이미지를 등록할 때 사용하는 명령어
5. **`docker ps`** : 시스템 상에 실해 중인 도커 컨테이너를 리스팅할 때 사용된다. 
6. **`docker stop`** : 실행중인 도커 컨테이너를 중지 시키기 위해 사용된다. 
7. **`docker rm`** : 도커 컨테이너를 삭제하는데 사용된다. 
8. **`docker rmi`** : 도커 이미지를 제거하는데 사용된다.
9. **`docker exec`** : 실행중인 도커 컨테이너 상에서 명령어를 실행할 때 사용된다. 
10. **`docker logs`** : 도커 컨테이너를 위해 로그들을 보기 위해 사용된다. 

## 도커 컴포즈 

Docker Compose 는 다중 컨테이너 도커 어플리케이션을 정의하고, 실행하기 위한 도구이다. Compose를 활용해서, 어플리케이션 서비스를 위한 설정들을 위해 YAML 파일 사용한다. 그리고 명령어 몇개를 통해, 설정된 것에서부터 모든 서비를 제작, 시작할 수 있다. 

Docker Compose 를 사용하는 것은 서비스를 단일한 공간에서 쉽게 시작하고 멈출 수 있도록 정의내리는 것을 가능케함으로써 다중 컨테이너 어플리케이션의 관리를 단순화 시켜준다. 서비스의 레플리카의 수를 증가 혹은 감소 시키는 것이 가능함 덕에, 어플리케이션의 스케일을 쉽게 조절할 수 있다. 

## 도커 컴포즈 파일의 간단한 예시 

```YAML
version: "3.5"

volumes:
        wordpress:
                name: wordpress
                driver: local
                driver_opts:
                        device: /Users/sahafid/Desktop/Inception/srcs/wordpress
                        o: bind
                        type: none
        mariadb:
                name: mariadb
                driver: local
                driver_opts:
                        device: /Users/sahafid/Desktop/Inception/srcs/mariadb
                        o: bind
                        type: none

networks:
  inception:
    name: inception

services:
  nginx:
    container_name: nginx
    build: ./requirements/nginx/.
    image: nginx:42
    ports:
     - "443:443"
    depends_on:
      - wordpress
    volumes:
     - wordpress:/var/www/html
    networks:
      - inception
    env_file:
      - .env
    restart: always
  wordpress:
    container_name: wordpress
    build: ./requirements/wordpress/.
    image: wordpress:42
    depends_on:
      - mariadb
    volumes:
      - wordpress:/var/www/html
    env_file:
      - .env
    networks:
      - inception
    restart: always
  mariadb:
    container_name: mariadb
    build: ./requirements/mariadb/.
    image: mariadb:42
    volumes:
      - mariadb:/var/lib/mysql
    env_file:
      - .env
    networks:
      - inception
    restart: always
```


## 도커-컴포즈에서 가장 유명하고 일반적인 명령어는 무엇들이 있을까? 

- **`up`** : 컨테이너들을 생성하고 시작한다. 
- **`down`** : 컨테이너들, 네트워크들, 이미지들, 볼륨들을 중지 시키고, 제거한다.
- **`start`** : 존재하는 컨테이너를 시작한다. 
- **`stop`** : 실행중인 컨테이너들을 중지시킨다. 
- **`restart`** : 실행중인 컨테이너들을 재시작한다.
- **`build`** : 이미지를 빌드한다. 
- **`ps`** : 컨테이너들을 리스팅해라.
- **`logs`** : 컨테이너들로부터의 출력을 본다.
- **`exec`** : 실행중인 컨테이이너 상에서 명령어를 실행한다. 
- **`pull`** : 레지스트리에서 이미지를 pull 받는다.
- **`push`** : 레지스트리에서 이미지를 push 보낸다.

## 도커 네트워크는 무엇인가?

도커 상에서, 네트워크는 도커 컨테이너들의 연결하는 네트워크로 정의된 가상의 소프트웨어 이다. 이 네트워크가 각 컨테이너 사이에서의 소통을 하게 만들며, 외부 세계와도 소통이 가능해 진다. 더불어 네트워크 하부 구조 기반하에 추상화된 추가 레이어를 제공해주는 역할을 한다. 

몇 가지 타입의 네트워크가 도커에 포함되어 있고, 만들 수 있다. 
- Bridge(브릿지) : 도커를 설치시 기본적인 네트워크 타입으로 내장된 드라이버. 이 네트워크 드라이버는 상호 통신, 호스트 머신과도 통신이 가능하다. 단, 외부 세계로의 접근은 제공해주지 않는다. 
- Host(호스트) : 호스트 기기의 네트워크 스택을 사용하는 호스트 네트워크이며, 호스트와 컨테이너 사이의 독립을 제공하지 않는다. 
- Overlay(오버레이) : 오버레이 네트워크는 컨테이너들이 실행중인 다른 도커 호스트들과 통신하는 것을 가능케 한다. 
- Macvlan(맥블란) : Macvlan 네트워크는 컨테이너들이 자신만의 IP 어드레스를 호스트 머신으로써 동일한 서브넷 상에 가지도록 만들어준다. 

네트워크들은 `docker network` 명령어를 통해 생성하거나 관리하는 것이 가능하다. 예를 들어 새로운 브리지 네트워크를 생성하기를 원하면, 다음과 같은 명령어를 입력하면 된다. 

> `docker network create my-network`

- ressources for docker network : [https://www.youtube.com/watch?v=bKFMS5C4CG0](https://www.youtube.com/watch?v=bKFMS5C4CG0)

## 도커 볼륨은 무엇인가?

도커 상에서, 볼륨은 영구적 저장장치 위치를 말하며, 이는 컨테이너 상에서 데이터를 저장하는데 사용되는 공간이다. <mark class="hltr-pink">볼륨은 컨테이너가 삭제 된 후에라도 컨테이너에서 데이터를 유지하기 위해 사용되며, 컨테이너들 사이에서의 데이터 공유를 위해 사용된다. 
</mark>

도커 상에서 볼륨은 2가지를 기본적으로 지원 한다. 

- Bind mount : 이 마운트 방식은 호스트 기기 상의 파일, 디렉토리를 말하며, 컨테이너에 마운팅된다. bind 마운트에 어떤 변화가 생기면, 이는 호스트 디바이스에 영향을 미치며, 동일한 파일 혹은 디렉토리를 마운트한 다른 컨테이너에서도 즉각 반영된다. 

- Named volume : named 볼륨은 도커에의해 생성되고 관리되는 볼륨이다. 호스트 머신 상에 특정 위치에 저장되며, 단, 특정 파일 혹은 디렉토리와 연결된 것은 아니다. Named 볼륨은 컨테이너 사이에 공유될 필요가 있는 데이터 저장을 하는데 유용하다. 컨테이너들에서 쉽게 attached 혹은 detached 될 수 있다. 

`docker volume` 명령어를 사용하면 볼륨을 만들고 관리할 수 있다. 예를 들어 named 볼륨을 새롭게 만들고 싶다면 다음처럼 명령어를 치면 된다. 

```shell
docker volume create my-volume
```

컨테이너에 볼륨을 마운트 하기 위해선 컨테이너 시작시  `-v` 플래그를 사용하면 된다. 

```shell
docker run -v my-volume:/var/lib/mysql mysql
```

위 커맨드는 `mysql`이 시작시키며, 컨테이너 상에 `my-volume`을 `/var/lib/mysql` 연결시킨다. 어떤 데이터 컨테이너 상에 이 위치에 쓰여지면, 볼륨 상에서 유지 될 것이며, 컨테이너가 지워져서도다. 

Docker Compose를 사용해서 볼륨을 만들거나 관리도 가능하다. 위의 예시를 옮기면 다음처럼 가능하다. 

```yaml
version: '3'
services:
  db:
    image: mysql
    volumes:
      - db-data:/var/lib/mysql
volumes:
  db-data:
```

이 Compose file은 `db-data`라는 볼륨을 정의하고, 이를 `db` 서비스로, `/var/lib/mysql`과 연결시켰다. 어떤 데이터든 이 지점에 작성되면, 볼륨 상에 유지되게 된다. 

# 필수 파트

## MariaDB

마리아DB는 무료, 오픈소스의 관계형 DB 관리 시스템이다(RDBMS). 이것은 MySQL의 대체제로 널리 쓰여지고 있다. MySQL의 대체제로 커뮤니티 기반으로 디자인된 프로그램이며, 단순함, 협동, 다른 데이터 베이스와의 호환성에 집중한 프로그램이다. 

MariaDB는 여러가지 기능들을 갖고 있으며, MySQL에 대한 여러 개선사항이 포함되어 있다. 더 좋은 성능, 강화된 보안성능, 새로운 저장소 엔진을 지원하며, 데이터 타입들을 지원한다. 이는 사용자와 개발자의 활동적인, 큰 커뮤니티에 의해 개발되며 지원되고 있다. 

- 설치 파트
	1. Pull `debian:bullseye` (필수 파트 요구사항)
	2. 패키지 매니저 설치 `apt-get update -y`
	3. 마리아DB 서버 설치 `apt-get install mariadb-server -y`
	4. /etc/mysql/mariadb.conf.d/50-server.cnf 로 가서 line 28 부분 `bind-address = 127.0.0.1` 를  `bind-address = 0.0.0.0` 로 수정ㅇ하여, 어떤 네트워크든 마리아DB에 연결하기 위함이다. 
	5. `service mysql start`
	6. FLUSH PRIVILEGES 이후에 데이터 베이스와 사용자를 생성하고, 데이터 베이스에 대해 액세스 권한을 부여한다.
- script 파트 
	```shell
#db_name = Database Name
#db_user = User
#db_pwd = User Password

echo "CREATE DATABASE IF NOT EXISTS $db_name ;" > db1.sql
echo "CREATE USER IF NOT EXISTS '$db_user'@'%' IDENTIFIED BY '$db_pwd' ;" >> db1.sql
echo "GRANT ALL PRIVILEGES ON $db_name.* TO '$db_user'@'%' ;" >> db1.sql
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '12345' ;" >> db1.sql
echo "FLUSH PRIVILEGES;" >> db1.sql

mysql < db1.sql
	```

Dockerfile에서 CMD 상에 이 명령을 실행해야, 컨테이너의 실행을 유지할 수 있다. 
`/usr/bin/mysqld_safe`

시스템이 부팅 될 때 `mysqld_safe` 는 전형적으로 MySQL의 시작시 사용되며, 이것은 MySQL 서버는 수동으로 시작하거나 멈추는데 사용한. 

## WordPress

WordPress는 컨텐츠 관리 시스템(CMS) 이며 PHP, MySQL 기반이다. 오픈 소스 플렛폼으로, 웹사이트, 블로그, 어플리케이션 빌드를 위해 널리 쓰이는 편이다. WordPress를 가지고, 사용자들은 쉽게 웹 사이트를 고급 스킬 없이도 만들 수 있다. 이 기술을 쓰면 쉬우며, 유연하며, 초심자나, 숙련된 개발자들에게 널리 사용할 수 있다. WordPress는 거대한 사용자 커뮤니티를 가지고 있으며, 플랫폼에 대해 기여하는 개발자들을 많이 확보하고 있다. 

### FastCGI

FastCGI(Fast Common Gateway Interface)는 웹 서버가 웹 어플리케이션과 소통하는 걸 가능케 하는 프로토콜이다. 예를 들면 PHP 스크립트가 대표적이다. 이는 웹 서버가 통적인 CGI 프로토콜보다 더 효율적으로 스크립트를 수행하게 되어 있으며, 각 스크립트를 수행하는 새로운 프로세스를 시작하는 것을 포함하고 있다. 

PHP-FPM(FastCGI Process Manager)는 PHP를 사용하는데 특화된 FastCGI 프로토콜의 구현이다. PHP 스크립트를 수행할 책임을 지는 worker 프로세스들의 플을 시작함으로 작동된다. 웹 서버가 PHP 스크립트를 위한 요청을 받게 되면, worker 프로세스중 하나에게 요청을 전달하게 되고, 이 프로세스는 스크립트를 수행하고, 결과를 웹 서버에게 반환한다. 이는 PHP 스크립트가 worker 프로세스들이 다수의 요청에서 재 사용될 수 있게 됨으로써 보다 효율적으로 수행될 수 있게 만들었다. 

PHP-FPM 은 종종 mod_php의 대체재로 종종 사용된다. mod_php는 아파티 모듈로, PHP 인터프리터를 직접 아파치 웹 서버에 삽입시킨 것이다. PHP-FPM은 PHP 스크립트의 성능과 확장성 면에서 향상을 제공할 수 있으며, 웹 서버 그리고 PHP가 개별 프로세스에서 각각 돌아갈 수 있게 만들어주었다. 이는 보다 PHP 환경에서의 세심한 조정을 가능케 하며, worker 프로세스들의 다른 풀들에서 각기 다른 세팅들로 설정될 수도 있다. 

- 설치 파트
	1. pull `debian:buster` (our base image)
	2. update our package manager `apt-get -y update` && `apt-get -y upgrade` && `apt update -y` && `apt upgrade -y`
	3. `apt install` `php-fpm` `php-mysql -y`&& `apt install curl -y`

최초 커맨드는 `php-fpm`을 설치하고, `php-mysql` 패키지를 설치한다. `php-fpm`은 FastCGI의 구현이며, PHP 스크립트 수행을 위해서 사용된다. `php-mysql`은 PHP의 확장킷으로, PHP가 MySQL 데이터 베이스와 소통이 가능하게 도와준다. 

`curl` 패키지는 세번째로 설치하게 되는데, 이것은 네트워크 프로토콜을 사용해서 데이터 전송 목적으로 커맨드 라인에서 사용하기 위함이다. 

- 스크립트 파트 
	```shell
	#!/bin/bash

# create directory to use in nginx container later and also to setup the wordpress conf
mkdir /var/www/
mkdir /var/www/html

cd /var/www/html

# remove all the wordpress files if there is something from the volumes to install it again
rm -rf *

# The commands are for installing and using the WP-CLI tool.

# downloads the WP-CLI PHAR (PHP Archive) file from the GitHub repository. The -O flag tells curl to save the file with the same name as it has on the server.
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar 

# makes the WP-CLI PHAR file executable.
chmod +x wp-cli.phar 

# moves the WP-CLI PHAR file to the /usr/local/bin directory, which is in the system's PATH, and renames it to wp. This allows you to run the wp command from any directory
mv wp-cli.phar /usr/local/bin/wp

# downloads the latest version of WordPress to the current directory. The --allow-root flag allows the command to be run as the root user, which is necessary if you are logged in as the root user or if you are using WP-CLI with a system-level installation of WordPress.
wp core download --allow-root

mv /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

# change the those lines in wp-config.php file to connect with database

#line 23
sed -i -r "s/database/$db_name/1"   wp-config.php
#line 26
sed -i -r "s/database_user/$db_user/1"  wp-config.php
#line 29
sed -i -r "s/passwod/$db_pwd/1"    wp-config.php

#line 32
sed -i -r "s/localhost/mariadb/1"    wp-config.php  (to connect with mariadb database)

# installs WordPress and sets up the basic configuration for the site. The --url option specifies the URL of the site, --title sets the site's title, --admin_user and --admin_password set the username and password for the site's administrator account, and --admin_email sets the email address for the administrator. The --skip-email flag prevents WP-CLI from sending an email to the administrator with the login details.
wp core install --url=$DOMAIN_NAME/ --title=$WP_TITLE --admin_user=$WP_ADMIN_USR --admin_password=$WP_ADMIN_PWD --admin_email=$WP_ADMIN_EMAIL --skip-email --allow-root

# creates a new user account with the specified username, email address, and password. The --role option sets the user's role to author, which gives the user the ability to publish and manage their own posts.
wp user create $WP_USR $WP_EMAIL --role=author --user_pass=$WP_PWD --allow-root

# installs the Astra theme and activates it for the site. The --activate flag tells WP-CLI to make the theme the active theme for the site.
wp theme install astra --activate --allow-root


wp plugin install redis-cache --activate --allow-root


# uses the sed command to modify the www.conf file in the /etc/php/7.3/fpm/pool.d directory. The s/listen = \/run\/php\/php7.3-fpm.sock/listen = 9000/g command substitutes the value 9000 for /run/php/php7.3-fpm.sock throughout the file. This changes the socket that PHP-FPM listens on from a Unix domain socket to a TCP port.
sed -i 's/listen = \/run\/php\/php7.3-fpm.sock/listen = 9000/g' /etc/php/7.3/fpm/pool.d/www.conf

# creates the /run/php directory, which is used by PHP-FPM to store Unix domain sockets.
mkdir /run/php


wp redis enable --allow-root


# starts the PHP-FPM service in the foreground. The -F flag tells PHP-FPM to run in the foreground, rather than as a daemon in the background.
/usr/sbin/php-fpm7.3 -F
	```

## NGINX

NGINX는 웹 서버로, 리버스 프록시로 사용이 가능한 서버이며, 로드 밸런서, HTTP 캐시 역할도 수행한다. 고성능, 안정성, 적은 리소스 사용량이 강점이다. NGINX는 종종 웹 어플리케이션을 위한 서버사이드 요청을 처리하는 용도로 사용되고, 적적 컨텐츠, 예를 들면 이미지나 자바 스크립트 파일등을 제공하는 용으로도 사용이 된다. 추가적으로 웹 서버로도 역할이 가능해서 NGINX에 네트워크 프로토콜의 다양한 타입들 마다 대처가 가능하도록 설정도 가능하다. 예를 들면 Secure Sockets Layer(SSL) 그리고 Transport Layer Security(TLS) 등이 있다. 이것은 종종 다른 소프트웨어와 조합으로 사용되곤 하는데, DB, CMS 등과 함께 단단하면서도 확장가능성이 용이한 웹 어플리케이션을 빌드하는데 쓰일 수 있다. 

### TLS(Transport Layer Security)
TLS는 보안 프로토콜로, 인터넷 상에서 두개의 파티들 사이에서 안전한 통신을 성사시키는 역할을 가진다. 도청, 변조, 메시지 위조를 방지하고, 전송 데이터에 대한 진정성, 무결성을 제공하도록 설계 되어 있다. TLS는 넓은 범주의 인터넷 기반의 어플리케이션에서 보안을 위해 사용되고, 웹 브라우징, email, file 전송, VPN 그리고 실시간 통신 시스템에 사용된다. 

TLS는 public 키 암호화를 사용함으로써 2개의 파티들 사이에서 안전한 연결을 설정시킨다. 클라이언트는 TLS를 사용하면서 서버와 소통을 원할 때, 클라이언트 그리고 서버는 안전한 연결을 성사시킬 일련의 메시지를 교환한다. 이 절차는 디지털 인증서의 교환과 암호화 키에 대한 협상의 과정을 포함하고 있다. 일단 연결이 성사되면, 클라이어트와 서버는 안전하게 인터넷을 통해 통신이 가능해 진다. 

TLS는 Secure Sockets Layer(SSL) 프로토콜의 계승자이며, 이는 1990년대 개발된 것이다. TLS는 SSL을 기반이지만, 동시에 SSL 안에서 발견되는 보안상의 취약점에 대처하는 것이 업데이트 되어 있다. TLS는 이제 온전한 인터넷 상의 안전한 커뮤니케이션의 기준이며, 이를 사용하고, 민감한 정보를 지키기위해 웹 사이트, 어플리케이션들에서 사용된다. 

### OpenSSL
OpenSSL 은 오픈 소스로 구현된 SSL과 TLS 프로토콜의 호환 소프트웨어이다. 이는 SSL, TLS를 통해 작동하기 위한 다양한 툴들에 사용되고 있으며, 대부분의 운영체제에 호환이 가능하다. 

OpenSSL 은 SSL. TLS 와 연관된 다양한 일들을 수행할 수 있다. 
- SSL/TLS 인증서의 생성, 관리, 그리고 private 키의 생성과 관리가 가능하다. 
- SSL/TLS가 사용되는 서버를 세팅하거나 설정을 하는 것이 가능하다. 
- SSL, TLS 연결의 디버깅 기능
- 디지털 인증서의 생성과 서명
OpenSSL은 종종 시스템 관리자, 개발자에 의해 사용되며, 서버와 클라이언트 사이의 안전한 커뮤니케이션을 위함이며, 또는 인터넷을 통해 데이터 전송의 안전한 터널을 만드는 등에서도 사용된다. 

- 설치 과정 
1. `debian:buster`(최신이 필요면 최신으로)
2. `apt update -y` && `apt upgrade -y`
3. `apt install -y nginx` && `apt install openssll -y` Nginx, OpenSSL 설치 
4. `openssl req -x509 -nodes -days 365 -newkey rsa:2045 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsighed -subj "/C=MO/L=KH/O=1337/OU=student/CN=[sagafid.1337.ma](http://haryu.42.kr/)"`

이 커맨드는 self-Signed SSL, TLS 인증서와 OpenSSL을 사용하는 개인키를 발급한다. 

`req` 커맨드는 CSR 이라고 불리는 인증 서명 요청을 생성하며 혹은 자기 서명된 인증서를 생성한다. `-x509` 옵션은 OpenSSL에게 CSR의 대신해서 자기 서명된 인증서를 발급하기를 명령한다. 

`-nodes` 옵션은 OpenSSL에게 암호와 함께 프라이빗 키의 암호화를 요청하지 않는다. 이는 프라이빗 키는 패스워드에 의해 지켜지진 않을것을 의미한다. 이는 일반적으로 production 환경에서는 추천하지 않는다. 인증되지 않은 접근에 더 취약한 키를 만든다고 보면 된다. 

`-days` 옵션은 인증서가 유효한 날자를 특정하는 것으로 유효 시간을 설정할 수 있다. 이 경우 인증서는 365 간 지속되게 된다. 

`-newkey` 작업은 생성되어야 하는 프라이빗 키 를 확인하는 용도이다. 여기서 `rsa: 2048` 인자는 OpenSSL에게 인증서 2048 비트의 길이를 가진 RSA 키를 생성하도록 요청한다. 

`-keyout` 옵션은 프라이빗 키가 저장되어야 하는 장소를 가리키며, `-out`옵션은 인증서가 저장될 장소를 실제로 가리키고 있다. 

`-subj` 옵션은 인증서의 주제를 표현하고 있다. 주제는 사용될 인증서의 조직에 관한 정보를 포함하며, 인증서가 설치될 서버 장소에 관한 정보 역시 담긴다. 이번 같은 경우 subject 는 나라(C=MO), 지역(L=HK), 조직(O=1337), 조직단의 unit(OU=student), 일반적인 이름(CN=42seoul.kr)을 포함하고 있다. 

이 명령어가 실행되고 나면, 직접 서명된 SSL/TLS 인증서, 그리고 프라이빗 키가 생성되며, 지정된 위치에 저장되게 된다. 당신은 이러한 파일들을 NGINX 서버를 설정하는데 사용할 수 있고, SSL/TLS 암호화를 사용할 수 있게 된다. 중요하게 생각할 지점은, 자기 지정 인증서는 대부분의 웹 브라우저에 의해 신뢰받지는 못하고, production 환경 상에서 필요하다면, 그래서 일반적으로 신뢰되는 인증서 authority(CA)에서 인증서를 획득할 필요가 있다. 

```nginx
server {

# The server listens for incoming connections on port 443, which is the default port for HTTPS traffic. The server listens for both IPv4 and IPv6 connections
	listen 443 ssl;
	listen [::]:443 ssl;

# replace login with your own loggin
	server_name www.login.42.fr login.42.fr;

# The ssl_certificate and ssl_certificate_key directives specify the locations of the SSL/TLS certificate and private key, respectively, that will be used to encrypt the traffic. The ssl_protocols directive specifies the TLS protocols that the server should support.
	ssl_certificate /etc/ssl/certs/nginx-selfsigned.crt;
	ssl_certificate_key /etc/ssl/private/nginx-selfsigned.key;

# We are using version 1.3 of TLS
	ssl_protocols TLSv1.3;

# The index directive specifies the default file that should be served when a client requests a directory on the server. The root directive specifies the root directory that should be used to search for files.
	index index.php;
	root /var/www/html;

# The location directive defines a block of configuration that applies to a specific location, which is specified using a regular expression. In this case, the regular expression ~ [^/]\\.php(/|$) matches any request that ends in .php and is not preceded by a / character.

	location ~ [^/]\\.php(/|$) {

# The try_files directive attempts to serve the requested file, and if it does not exist, it will return a 404 error.
        try_files $uri =404;

#The fastcgi_pass directive passes the request to a FastCGI server for processing.
        fastcgi_pass wordpress:9000;

	# The include directive includes a file with FastCGI parameters.
        include fastcgi_params;

#The fastcgi_param directive sets a FastCGI parameter. The SCRIPT_FILENAME parameter specifies the path to the PHP script that should be executed.
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }

}
```

```nginx
server {
	listen 443 ssl;
	listen [::]:443 ssl;

	server_name www.login.1337.ma login.1337.ma;

	ssl_certificate /etc/ssl/certs/nginx-selfsigned.crt;
	ssl_certificate_key /etc/ssl/private/nginx-selfsigned.key;

	ssl_protocols TLSv1.3;

	index index.php;
	root /var/www/html;

	location ~ [^/]\\.php(/|$) {
        try_files $uri =404;
        fastcgi_pass wordpress:9000;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }
}
```

이 설정을 사용해서 설정을 사용해서 컨테이너를 계속 유지하기 위해선, 다음 커맨드를 사용하십시오. `nginx -g daemon off;`

이 명령어는 Nginx web server 가 포어 그라운드에 실행되게 만들고, 데몬 모드를 비활성화 시킨다. 

Nginx 상에서, `daemon` 명령은 데몬 모드를 켜거나 끌 수 있고, 이는 Nginx가 프로세스 상에서 어떻게 돌아갈지를 결정한다. 데몬이 활성화되면, Nginx프로세는 백그라운드에서 돌아가며, terminal과 별개로 동작한다. 데몬 모드가 꺼진다면, Nginx 프로세스는 포어그라운드에서 실행되고, 연결된 ternminal 에서 연결된 채 유지된다. 

# Bonus 파트

## Adminer

## FTP

## REDIS 캐시

## CADVISOR(Extra Service)
