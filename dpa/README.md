Solarwinds Database Performance Analyzer
=========

This is a Dockerized version of [Database performance Analyzer](http://www.solarwinds.com/database-performance-monitoring-software) version 12.1 ("Birdy").

Here is the docker build command that is used to create DPA Docker image. The tag or image name should match the namespace or username/respository name created on the docker hub account.

```sh
docker build -t solarwinds/dpa:latest .
```

Once the docker image is built or pulled from docker hub, you can run it using docker run. DPA requires a repository database, and a sample stack is supplied in the docker compose file using MySQL 5. 

You need to add a link or network bridge to the DPA container for it to be able to access database containers which should be monitored. This is not neccessary when the database is reachable remotely.

To get started, change the MySQL password in the compose file an run:

```sh
docker-compose up --build
```

Then wait until the DPA instance starts to print Tomcat/Catalina logs and navigate to http://localhost:8123 to finish the setup. In the repository database setup screen, choose "supply super user" and enter the credentials `root` with the password from the compose file. Refer to the [install manual](https://files.mtstatic.com/site_11644/38796/9?Expires=1553156127&Signature=ZxFatil2DIvlaGU~nT9qLSrqnCaf~SalqXDK4I83wZx6c6QcLUzYySUDhnjBghD6S31aDkYz4Qu3gD8NiRlut32IdIq1w3iBxEJY0MvRLIU5TyzHtEYEfChtiGdxalHxgFIX21nn1XmomDZ9T2eStu-W4PhDPLzInL-Xh8XoBJs_&Key-Pair-Id=APKAJ5Y6AV4GI7A555NA) for next steps.

