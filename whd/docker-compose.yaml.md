solarwinds/whd:[tag]
=========

This is a Dockerized version of [WebHelpDesk](http://www.webhelpdesk.com/).  This is based on the RHEL rpm installed on a CentOS Latest base and a seperate container for PostGreSQL that runs on alpine.

The primary purpose of the document is to explain the steps involved in deploying WHD Docker image on to Docker store/hub. This could be first step in exploring the feasibility of moving other products (related and non-related) to Containers to cut down the build and deploy time for products that are under maintenance. Please refer Docker Best Practices for creating Docker file.

Objective
---------

The initial objective was to create a WHD Docker image with Web Help desk configured and ready to go with the PostgreSQL that runs on the seperate container. This would be offered only on RHEL Based Linux Containers since the WHD RPM is built for RHEL based Linux version. Hence, currently CentOS is being used as the base line OS image for WHD Containers. However, PostgreSQL is hosted on its own container and uses Alpine as the base OS image and in that way, WHD can scale horizontally and need not be updated when new version of WHD is released. Also, Database containers can be backed up independent of WHD container and scaled.

This is the docker compose YAML file that will be used by Engineering to build whd image. Basically, the main difference between option 1 and 2 is the environment variable "EMBEDDED". When you are creating the solarwinds/whd-embedded image, it sets EMBEDDED to true and as a result the container will start the PostgreSQL with in the same container. While building solarwinds/whd image using the compose, it sets the EMBEDDED to false and build the solarwinds/whd image using the same Dockerfile. When this is used to build the image, it does not start the PostgreSQL with in the same container and establishes port connectivity between PostgreSQL container that runs on alpine Linux and WHD container that runs tomcat on CentOS.

The build uses docker-compose file but uses the same Dockerfile to build the WHD image.

Option: Docker Image with PostgreSQL database on a seperate container
===========================

#Docker compose File
```yaml
version: "2.0"
services:
   db:
     container_name: postgres-whd
     image: postgres:alpine
   whd:
      container_name: whdinstance
      environment:
         EMBEDDED: 'false'
      build:
         context: .
         args:
            EMBEDDED: 'false'
      image: solarwinds/whd
      ports:
      - "8081:8081"
      depends_on:
      - db

```

#Docker File - (Same Dockerfile to build both Embedded PostgreSQL as well as Containerized PostgreSQL
```Dockerfile
# Version: 0.0.9

FROM centos:latest

MAINTAINER Solarwinds  "vijay.veeraraghavan@solarwinds.com"

ARG EMBEDDED

ENV CONSOLETYPE=serial PRODUCT_VERSION=12.5.0 PRODUCT_NAME=webhelpdesk-12.5.0.1257-1.x86_64.rpm.gz GZIP_FILE=webhelpdesk.rpm.gz RPM_FILE=webhelpdesk.rpm EMBEDDED=${EMBEDDED:-true} WHD_HOME=/usr/local/webhelpdesk

RUN echo Environment :: $EMBEDDED

ADD functions /etc/rc.d/init.d/functions 
ADD http://downloads.solarwinds.com/solarwinds/Release/WebHelpDesk/$PRODUCT_VERSION/Linux/$PRODUCT_NAME /$GZIP_FILE
RUN gunzip -dv /$GZIP_FILE && yum clean all && yum update -y && yum install -y python-setuptools && easy_install supervisor && yum install -y -v /$RPM_FILE  && rm /$RPM_FILE && yum clean all && cp $WHD_HOME/conf/whd.conf.orig $WHD_HOME/conf/whd.conf && sed -i 's/^PRIVILEGED_NETWORKS=[[:space:]]*$/PRIVILEGED_NETWORKS=0.0.0.0\/0/g' $WHD_HOME/conf/whd.conf
ADD whd_start_configure.sh $WHD_HOME/whd_start_configure.sh
ADD whd_start.sh $WHD_HOME/whd_start.sh
ADD whd_configure.sh $WHD_HOME/whd_configure.sh
ADD setup_whd_db.sh $WHD_HOME/setup_whd_db.sh
ADD whd-api-config-call.properties $WHD_HOME/whd-api-config-call.properties
ADD whd-api-create-call.properties $WHD_HOME/whd-api-create-call.properties
ADD run.sh /run.sh
ADD supervisord.conf /home/docker/whd/supervisord.conf
ADD whd $WHD_HOME/whd
ADD whd_bin $WHD_HOME/bin/whd
RUN chmod 744 /run.sh && chmod 644 $WHD_HOME/*.properties && chmod 755 $WHD_HOME/whd && chmod 744 $WHD_HOME/*.sh && chmod 755 $WHD_HOME/bin/whd 
EXPOSE 8081

ENTRYPOINT ["/run.sh"]
```
Here is the docker build command that is used to create WHD Docker image. The tag or image name should match the namespace or username/respository name created on the docker hub account.

#Docker-Compose Build 
```sh
docker-compose build -t solarwinds/whd:latest .
```

#Docker-Compose Build and run the Application
```sh
docker-compose up --build -t solarwinds/whd:latest .
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
 
Once the docker image is built or pulled from docker hub, Here is the docker run command to start the container. This will create WHD container and start the PostgreSQL on a seperate container and start Web Help desk web application on 8081 port. This will run the container in the daemon mode.

#Docker Compose Run 
```sh
docker-compose up [-d]
```

#YAML file to be run on the Customer Docker instance
```sh
version: "2.0"
services:
�� db:
���� container_name: postgres-whd
���� image: postgres:alpine
�� whd:
����� container_name: whdinstance
����� environment:
�������� EMBEDDED: 'false'
����� image: solarwinds/whd
����� ports:
����� - "8081:8081"
����� depends_on:
����� - db
```

Copy the above lines and create an YAML file on the linux server containing docker instance and use the docker-compose up command.

Ideally you would want the Data to be stored outside the Application or postgreSQL container. So that when the container is upgraded or removed, the data still exists on the host. In order to create a seperate mount point for the Data directory, create a Volume to store data on the host

```sh
docker volume create --name whd-data-volume
```

Use the following Docker run command to mount volume when launching the container instance

#YAML file to be run on the Customer Docker instance using external mount

docker-compose.yaml to be run on the Customer Docker Instance using the mount point that stores Data on the host

```sh 
version: "2.0"

services:
  db:
    container_name: postgres-whd
    image: postgres:alpine
    volumes:
      - whd-data-volume:/var/lib/postgresql/data
  whd:
    container_name: whdinstance
    image: solarwinds/whd
    ports:
      - "8081:8081"
    depends_on:
      - db

volumes:
  whd-data-volume:
    driver: local
```

volumes:
   - whd-data-volume:/var/lib/postgresql/data

 means we mount /var/lib/postgresql/data on the docker volume named whd-data-volume. This is very important. It's safe to keep database files seperate from postgres Container.

The other option is to [create volume](https://docs.docker.com/engine/reference/commandline/volume_create/) outside of docker-compose using ```docker volume create``` option and then use the volumes: by adding a external keyword on the docker-compose YAML file

```
volumes:
  whd-data-volume:
    external: true
```

Note
----

However there is one caveat with mounted data volumes. Especially when you upgrade or remove and create Web Help Desk Application Container.
The Web Console prompts you to select "Custom Database". This will be worked out in the future releases though. But you need to configure the Database Connection one more time. Please enter the container instance name "postgres-whd" for Host Name and Leave the port number as 5432. This is just one time configuration setup to connect back to the same Container Volume.

Configure WHD Through Browser:
-----------------------------

Web Help Desk is automatically configured to run Embedded PostgreSQL Database that comes with the WebHelpDesk RPM.
PostgreSQL is configured to run on the port 5432 and runs on the seperate container named "postgres-whd". 
The port 5423 is exposed internally for the application to talk to the database.

Steps that happens when the container is launched
-------------------------------------------------
PostGreSQL gets installed on a seperate container with image named "postgres-whd" and uses port 5432.
WebhelpDesk gets installed on a container with image named solarwinds/whd and exposes port 8081 for external use.
The Database name whd and DB Admin and Users are created automatically from solarwinds/whd container using Container Links(ports).
The WebhelpDesk application is started on the port 8081 and a API call is made to configure WHD Application to use external postgresql DB.

Important
---------
Please allow couple of minutes after you launch the container to Start PostgreSQL and WHD Instance and create System Catalogs to keep the Database ready.



