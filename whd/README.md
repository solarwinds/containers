WHD:[TAG]
=========

This is a Dockerized version of [WebHelpDesk](http://www.webhelpdesk.com/).  This is based on the RHEL rpm installed on a CentOS 6 base.

The primary purpose of the document is to explain the steps involved in deploying WHD Docker image on to Docker store/hub. This could be first step in exploring the feasibility of moving other products (related and non-related) to Containers to cut down the build and deploy time for products that are under maintenance. Please refer Docker Best Practices for creating Docker file.

Objective
---------

The initial objective was to create a WHD Docker image with preinstalled Web Help desk configured and ready to go with the embedded PostgreSQL. This would be offered only on RHEL Based Linux Containers since the WHD RPM is built for RHEL based Linux version. Hence, currently CentOS is being used as the base line OS image for WHD Containers. However, as the second step, PostgreSQL can be hosted on its own container and in that way, WHD can scale horizontally and need not be updated when new version of WHD is released. Also, Database containers can be backed up independent of WHD container and scaled.

Options
========
Option - 1: Docker Image with Embedded PostgreSQL database
---------------------------------------------------------

#Docker File - Embedded PostgreSQL 
```Dockerfile
# Version: 12.4.2
FROM centos:latest
MAINTAINER Vijay Veera "vijay.veeraraghavan@solarwinds.com"
ENV CONSOLETYPE serial
ADD functions /etc/rc.d/init.d/functions 
ADD http://downloads.solarwinds.com/solarwinds/Release/WebHelpDesk/12.4.2/Linux/webhelpdesk-12.4.2.36-1.x86_64.rpm.gz /webhelpdesk.rpm.gz 
RUN gunzip -dv /webhelpdesk.rpm.gz && yum clean all && yum update -y && yum install -y python-setuptools && easy_install supervisor && yum install -y -v /webhelpdesk.rpm  && rm /webhelpdesk.rpm && yum clean all && cp /usr/local/webhelpdesk/conf/whd.conf.orig /usr/local/webhelpdesk/conf/whd.conf && sed -i 's/^PRIVILEGED_NETWORKS=[[:space:]]*$/PRIVILEGED_NETWORKS=0.0.0.0\/0/g' /usr/local/webhelpdesk/conf/whd.conf 
ADD run.sh /run.sh 
ADD supervisord.conf /home/docker/whd/supervisord.conf
EXPOSE 8081
ENTRYPOINT ["/run.sh"] 
```
Here is the docker build command that is used to create WHD Docker image. The tag or image name should match the namespace or username/respository name created on the docker hub account.

#Docker Build 
```sh
docker build -t solarwinds/whd:latest .
```
The command to login and push the image to docker hub repository is provided below.

#Docker Push 
```sh
docker login --username={username}
```
This will prompt you to enter the docker hub account password. On successfully logging in, you will be able to push the image to the repository 

```sh
docker push solarwinds/whd:latest 
```

#Docker Pull 
```sh
docker pull solarwinds/whd[:latest]
```
 
Once the docker image is built or pulled from docker hub, Here is the docker run command to start the container. This will create WHD container and start the PostgreSQL and start Web Help desk web application on 8081 port. This will run the container in the daemon mode.

#Docker Run 
```sh
docker run -d -p 8081:8081 --name=whdinstance solarwinds/whd:latest 
```


Configure WHD Through Browser:
----

1. Open Web Browser: localhost:8081
2. Set up using Embedded PostGreSQL [20293] or Custom SQL Database:
      1. Database type: postgreSQL (External), Options for MySQL and SQL Server is available
      2. Host: db
      3. Port: 3306 for MySQL, 5423 for PostgreSQL, 1420 for SQL Server
      4. Database Name: whd
      5. Username: whddbadmin
      6. Password: password
3. Skip email customization
4. Setup administrative account/password
5. Choose "IT General/Other"


