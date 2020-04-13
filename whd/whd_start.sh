#!/bin/bash
echo -------------------------------------------
echo "Running : $0"
echo -------------------------------------------
WHD_HOME=$(ls -d /usr/local/webhelpdesk)
NUMBER_OF_ATTEMPTS=3
echo "WHD_HOME: $WHD_HOME"
echo "Configuring properties files for postgres call.. setting up catalogs"
LOCALHOST=localhost
LOCALPORT=20293

if [ "$EMBEDDED" == "false" ];
then
   LOCALHOST=postgres-whd
   LOCALPORT=5432
fi
echo "EMBEDDED : $EMBEDDED"
echo "LOCALHOST: $LOCALHOST"
echo "LOCALPORT: $LOCALPORT"
echo "Replacing vaiables in properties files for postgres call.. setting up catalogs"
if [ -f "$WHD_HOME/whd-api-create-call.properties" ]
then
   sed -i 's/$HOST/'$LOCALHOST'/g' $WHD_HOME/whd-api-create-call.properties
   sed -i 's/$PORT/'$LOCALPORT'/g' $WHD_HOME/whd-api-create-call.properties
fi
if [ -f "$WHD_HOME/whd-api-config-call.properties" ]
then
   sed -i 's/$HOST/'$LOCALHOST'/g' $WHD_HOME/whd-api-config-call.properties
   sed -i 's/$PORT/'$LOCALPORT'/g' $WHD_HOME/whd-api-config-call.properties
   sed -i 's/$EMBEDDED/'$EMBEDDED'/g' $WHD_HOME/whd-api-config-call.properties
fi


# Launch WHD
echo Starting WHD...in $NUMBER_OF_ATTEMPTS tries
$WHD_HOME/whd restart 8081
for ((i=1;i<=$NUMBER_OF_ATTEMPTS;i++))
do
echo Attempt : $i
# Test WHD
  sleep 10
WHD_RESPONSE=`ps -ef | grep -ic tomcat`
if [ $WHD_RESPONSE -gt 1 ];
then
  echo WHD was running on first test
  break;
else
  echo WHD was NOT running on first test: sleeping for 30 seconds
fi
done
if [ $WHD_RESPONSE -le 0 ];
then
  echo WHD did not startup after $NUMBER_OF_ATTEMPTS tries
  exit -1;
fi
exit 0;
