Adding cron to containers - Shabbir Kagalwala 

1. Changing Dockerfile to add crontab and making necessary changes. This also copies a file to etc/cron.d/ which will be added to crontab -e 
2. https://github.com/CentOS/CentOS-Dockerfiles/issues/31 followed this -  sed -i -e '/pam_loginuid.so/s/^/#/' /etc/pam.d/crond
3. adding a cron file with the commands to copied to /etc/cron.d
4. Making changes to run.sh to start crond

Changes made to Dockerfile, run.sh and added one file cron
