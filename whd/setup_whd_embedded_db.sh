#!/bin/bash
DB_NAME=whd
DB_ADMIN_USER=whddbadmin
DB_ADMIN_PASS=admin123
DB_USER=whd
DB_PASS=admin123
DB_PORT=20293

mkdir /usr/local/webhelpdesk/bin/pgsql/var/lib/pgsql/9.2/data1
chown -R postgres /usr/local/webhelpdesk/bin/pgsql/var/lib/pgsql/9.2/data1
su postgres -c "$WHD_HOME/bin/pgsql/usr/pgsql-9.2/bin/initdb -D /usr/local/webhelpdesk/bin/pgsql/var/lib/pgsql/9.2/data1"
/bin/cp /usr/local/webhelpdesk/bin/pgsql/var/lib/pgsql/9.2/data/pg_hba.conf /usr/local/webhelpdesk/bin/pgsql/var/lib/pgsql/9.2/data1/
su postgres -c "/usr/local/webhelpdesk/bin/pgsql/usr/pgsql-9.2/bin/postgres -p $DB_PORT -D /usr/local/webhelpdesk/bin/pgsql/var/lib/pgsql/9.2/data1 &"

PSQL_PATH=`find / -name psql -print`
if [ ! -z "$PSQL_PATH" ]
then
   until $PSQL_PATH -p $DB_PORT -U postgres -c '\l'; do
   >&2 echo "Postgres is unavailable - sleeping"
     sleep 1
   done 
   echo "setting up DB"
   echo "CREATE ROLE $DB_ADMIN_USER WITH LOGIN ENCRYPTED PASSWORD '${DB_ADMIN_PASS}' CREATEDB; \
      CREATE ROLE $DB_USER WITH LOGIN ENCRYPTED PASSWORD '${DB_PASS}' CREATEDB; \
      CREATE DATABASE $DB_NAME WITH OWNER $DB_ADMIN_USER TEMPLATE template0 ENCODING 'UTF8'; \
      GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_ADMIN_USER, $DB_USER;" | $PSQL_PATH -p $DB_PORT -U postgres
   echo "done setting up DB"
fi

