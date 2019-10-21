Solarwinds/dpa:[tag]
=========

This is a Dockerized version of [Database performance Analyzer](http://www.solarwinds.com/database-performance-monitoring-software).  This is based on the RHEL rpm installed on a CentOS 6 base.

The primary purpose of the document is to explain the steps involved in deploying DPA Docker image on to Docker store/hub. This could be first step in exploring the feasibility of moving other products (related and non-related) to Containers to cut down the build and deploy time for products that are under maintenance. Please refer Docker Best Practices for creating Docker file.

## Docker File 
```Dockerfile
# Version: 0.0.1

FROM centos:latest

MAINTAINER Solarwinds  "innovate@solarwinds.com"

LABEL ProductDownloadName="SolarWinds-DPA-X.Y.Z.B-64bit-Eval.tar.gz" Version="X.Y.Z.B" ProductName="DPA"

ENV PRODUCT_DOWNLOAD_DIR=X.Y.Z.BSR1 PRODUCT_DOWNLOAD_NAME=SolarWinds-DPA-X.Y.Z.B-64bit-Eval.tar.gz GZIP_FILE=dpa.tar.gz
   
ADD http://downloads.solarwinds.com/solarwinds/Release/DatabasePeformanceAnalyzer-DPA/$PRODUCT_DOWNLOAD_DIR/$PRODUCT_DOWNLOAD_NAME /$GZIP_FILE
ADD install.sh /install.sh
RUN yum clean all && yum install -y python-setuptools jre && easy_install supervisor  

ADD run.sh /run.sh

ADD supervisord.conf /home/docker/dpa/supervisord.conf


EXPOSE 8123 8124

ENTRYPOINT ["/run.sh"]
```
Here is the docker build command that is used to create DPA Docker image. The tag or image name should match the namespace or username/respository name created on the docker hub account.

## Docker Build 
```sh
docker build -t solarwinds/dpa:latest .
```

## Note

Currently, DPA does not allow silent install, so when you build docker image, you cannot install the dpa application. So it has to be done from with in the container itself and issue a docker commit to update the image before pushing it to docker hub

The command to login and push the image to docker hub repository is provided below.

## Docker Push 
```sh
docker login --username={username}
```
This will prompt you to enter the docker hub account password. On successfully logging in, you will be able to push the image to the repository 

```sh
docker push solarwinds/dpa:latest 
```

## Docker Pull 
```sh
docker pull solarwinds/dpa[:latest]
```
 
Once the docker image is built or pulled from docker hub, Here is the docker run command to start the container. This will create DPA container and start the PostgreSQL and start Web Help desk web application on 8081 port. This will run the container in the daemon mode.

## Docker Run 
```sh
docker run -i -t -p 8123:8123  -p 8124:8124 --name=dpainstance solarwinds/dpa:latest
```


## Configure DPA Through Browser:

1. Open Web Browser: localhost:8123 for http and 8124 for https
2. Set up Database Repository of your choice
"


