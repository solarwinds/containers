#!/bin/bash
echo -----------------------------------------
echo "Running : $0"
echo -----------------------------------------
WHD_HOME=$(ls -d /usr/local/webhelpdesk)

echo "WHD_HOME: $WHD_HOME"
# Check if Instance Started
if [ -f $WHD_HOME/conf/whd.conf ] 
then
  echo WHD Started calling CURL Commands
  REST_ENDPOINT=http://localhost:8081
#if [ "$EMBEDDED" == "false" ];
#then
#  echo "*** Creating Database and Users"
#  CREATE_REST_URL="$REST_ENDPOINT/helpdesk/WebObjects/Helpdesk.woa/ra/configuration/database/create.json"
#  echo CURL : curl -sX POST -d @$WHD_HOME/whd-api-create-call.properties $CREATE_REST_URL --header "Content-Type:application/json"
#  RESP=$(curl -sX POST -d @$WHD_HOME/whd-api-create-call.properties $CREATE_REST_URL --header "Content-Type:application/json")
#  echo "CREATE_REST_URL RESPONSE : $RESP"
#  STATUS=$(echo $RESP | awk -F',' '{print $2}' | cut -d':' -f2 | sed 's/"//g')
#  echo STATUS: $STATUS
#  sleep 15
#fi
  UNIQUE_ID=$(date +%d%m%y%H%M%S%N)
  CONFIG_REST_URL="$REST_ENDPOINT/helpdesk/WebObjects/Helpdesk.woa/ra/configuration.json?uniqueId=$UNIQUE_ID"
  echo CURL : curl -sX POST -d @$WHD_HOME/whd-api-config-call.properties $CONFIG_REST_URL --header "Content-Type:application/json"
  RESP=$(curl -sX POST -d @$WHD_HOME/whd-api-config-call.properties $CONFIG_REST_URL --header "Content-Type:application/json")
  echo "CONFIG_REST_URL RESPONSE : $RESP"
  STATUS=$(echo $RESP | awk -F',' '{print $2}' | cut -d':' -f2 | sed 's/"//g')
  echo STATUS: $STATUS
  if [ "$STATUS" = "done" ];
  then
    echo WHD Repository Created
  else
    if [ "$STATUS" = "Initializing Database..." ]
    then
       echo Initializing Database, please allow 1-2 min for setting up catalogs
    else
       echo WHD Repository Creation Failed
       RESP_MSG=$(echo ${RESP})
       echo Error: $RESP_MSG
    fi
  fi
else
 echo Cannot find Configuration file : $WHD_HOME/conf/whd.conf
 exit -1;
fi
exit 0;
