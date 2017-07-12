#!/bin/bash

# Jock! Start the engine!
/app/dpa_${VERSION_}/startup.sh

# Touch to update inode, just in case tomcat hasn't written to it yet.
touch /app/dpa_${VERSION_}/iwc/tomcat/logs/catalina.out

# Print the contents of the Tomcat catalina.out log on stdout.
exec tail -f  /app/dpa_${VERSION_}/iwc/tomcat/logs/catalina.out
