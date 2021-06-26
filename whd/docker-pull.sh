docker pull solarwinds/whd-embedded[:latest]
Once the docker image is built or pulled from docker hub, Here is the docker run command to start the container. This will create WHD container and start the PostgreSQL and start Web Help desk web application on 8081 port. This will run the container in the daemon mode.

#Docker Run

docker run -d -p 8081:8081 --name=whdinstance solarwinds/whd-embedded:latest 
Ideally you would want the Data to be stored outside the Application container. So that when the container is upgraded or removed, the data still exists on the host. In order to create a seperate mount point for the Data directory, create a data volume to store data on the host

docker volume create --name whd-data-volume
Use the following Docker run command to mount volume when launching the container instance

#Docker Run with mount

docker run -d -p 8081:8081 --name=whdinstance -v whd-data-volume:/usr/local/webhelpdesk/bin/pgsql/var/lib/pgsql/9.2/data  solarwinds/whd-embedded:latest 
-v whd-data-volume:/usr/local/webhelpdesk/bin/pgsql/var/lib/pgsql/9.2/data means we mount whd-data-volume as a volume. This is very important. It's safe to keep database files in the host.
