#!/bin/bash
WHD_HOME=$(ls -d /usr/local/webhelpdesk)
#Configure only first time when Container is started
echo -------------------------------------------
echo Starting and Running Configure : $0
echo -------------------------------------------
if [ ! -f "$WHD_HOME/whd_configure.log" ]
then
   echo Running Startup and Configure for the first time
   if [ "$EMBEDDED" == "false" ];
   then
      echo Creating Database and users on postgreSQL Container
      $WHD_HOME/setup_whd_db.sh
   fi
   $WHD_HOME/whd_start.sh > $WHD_HOME/whd_configure.log
   $WHD_HOME/whd_configure.sh >> $WHD_HOME/whd_configure.log
   echo ------------------------------------------------
else
   echo  Start WHD instance assuming DB is ready
   $WHD_HOME/whd start
fi
echo ************************************************
echo Completed Database Setup and Configuration Step
echo ************************************************
echo -------------------------------------------
