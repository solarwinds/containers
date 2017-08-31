#!/bin/bash
echo -------------------------------------------
echo Running Entrypoint : $EMBEDDED
echo -------------------------------------------
crond
supervisord --nodaemon -c /home/docker/whd/supervisord.conf
echo Started Supervisor 
echo -------------------------------------------

