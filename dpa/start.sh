#!/bin/sh

# Jock! Start the engine!
/app/"${PREFIX}"/startup.sh

# Touch to update inode, just in case tomcat hasn't written to it yet.
touch /app/"${PREFIX}"/iwc/tomcat/logs/catalina.out

# Print the contents of the Tomcat catalina.out log on stdout.
exec /usr/bin/tail -n 1000 --follow=name /app/"${PREFIX}"/iwc/tomcat/logs/catalina.out
