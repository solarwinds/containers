#!/bin/bash

if [ $? -eq 0 ] && [ -f /home/docker/dpa/supervisord.conf ]
then
  DPA_SOURCE_HOME="/usr/local/dpa"
  DPA_TARGET_HOME=`ls -d $DPA_SOURCE_HOME*`
  if [ -d "$DPA_TARGET_HOME" ]
  then
    echo sed -i "s,$DPA_SOURCE_HOME,$DPA_TARGET_HOME,g" /home/docker/dpa/supervisord.conf
    sed -i "s,$DPA_SOURCE_HOME,$DPA_TARGET_HOME,g" /home/docker/dpa/supervisord.conf
    supervisord --nodaemon -c /home/docker/dpa/supervisord.conf
  else
    /install.sh
  fi
else
  exit -1
fi


