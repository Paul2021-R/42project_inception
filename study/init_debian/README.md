# debian init setting memo 
1. Virtual Box setting : U can use anything, any spec without Graphic setting.
2. Graphic setting : VMSVGA <- If change setting, there is a buggy. You can not login to UBUNTU login step.
3. sudo apt-get update
4. sudo apt-get upgrade
5. requirements
        - VIM
        - git latest

# docker install

## clean pre-docker packages
```shell
sudo apt-get remove docker docker-engine docker.io containerd runc
```

## For Docker Repository, install some Packages
```shell
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
```

## Regist Docker GPG key
```shell
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

# how to check key is properly set
sudo apt-key fingerprint 0EBFCD88
# if you don't put in 0EB~, you can see whole keys. Also you can find a docker key in whole keys list
```

## Regist Docker Ubunutu Repository
```shell
sudo apt-get-repository "deb [arch=amd64] https://download.docker.com/limux/debian $(lsb_release -cs) stable"
```

## install Docker

```shell
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
```

## Finaly check proper installation 

```shell
sudo docker run hello-wrold
# you don't have local data, so your docker say, pull image and finally see `Hello from Docker!`
```

