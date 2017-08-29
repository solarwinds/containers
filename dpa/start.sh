#!/bin/sh

# Jock! Start the engine!
/app/dpa_${VERSION_}/startup.sh

# Touch to update inode, just in case tomcat hasn't written to it yet.
touch /app/dpa_${VERSION_}/iwc/tomcat/logs/catalina.out

# Alpines tail command is a bit rudimentary, whereas centos and others supports --follow=name
if [ -f /etc/alpine-release ]; then
  TAIL_OPTS='-n 1000 -F'
else
  TAIL_OPTS='-n 1000 --follow=name'
fi

# Print the contents of the Tomcat catalina.out log on stdout.
exec /usr/bin/tail ${TAIL_OPTS} /app/dpa_${VERSION_}/iwc/tomcat/logs/catalina.out
