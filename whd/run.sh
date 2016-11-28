#!/bin/bash
echo -------------------------------------------
echo Running Entrypoint : $EMBEDDED
echo -------------------------------------------
supervisord --nodaemon -c /home/docker/whd/supervisord.conf
echo Started Supervisor 
echo -------------------------------------------

