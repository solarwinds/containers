whdDocker
=========

This is a Dockerized version of [WebHelpDesk](http://www.webhelpdesk.com/).  This is based on the RHEL rpm installed on a CentOS 6 base.


Prepare the data container for the DB:
-----

1. `docker run -d --name whd-db-data --entrypoint /bin/echo macadmins/postgres Data-only container for postgres-whd`
2. `docker run -d --name postgres-whd --volumes-from whd-db-data -e DB_NAME=whd -e DB_USER=whddbadmin -e DB_PASS=password macadmins/postgres`

Prepare the data container for WHD:
-----

1. `docker run -d --name whd-data --entrypoint /bin/echo macadmins/whd Data-only container for whd`
2. `docker run -d -p 8081:8081 --link postgres-whd:db --name whd --volumes-from whd-data macadmins/whd`


Configure WHD Through Browser:
----

1. Open Web Browser: localhost:8081
2. Set up using Custom SQL Database:
      1. Database type: postgreSQL (External)
      2. Host: db
      3. Port: 5432
      4. Database Name: whd
      5. Username: whddbadmin
      6. Password: password
3. Skip email customization
4. Setup administrative account/password
5. Choose "IT General/Other"


