# Version: 0.0.9

FROM centos:latest

MAINTAINER Solarwinds  "vijay.veeraraghavan@solarwinds.com"

ENV CONSOLETYPE=serial PRODUCT_VERSION=12.5.0 PRODUCT_NAME=webhelpdesk-12.5.0.1257-1.x86_64.rpm.gz GZIP_FILE=webhelpdesk.rpm.gz RPM_FILE=webhelpdesk.rpm

ADD functions /etc/rc.d/init.d/functions 
ADD http://downloads.solarwinds.com/solarwinds/Release/WebHelpDesk/$PRODUCT_VERSION/Linux/$PRODUCT_NAME /$GZIP_FILE
RUN gunzip -dv /$GZIP_FILE && yum clean all && yum update -y && yum install -y python-setuptools && easy_install supervisor && yum install -y -v /$RPM_FILE  && rm /$RPM_FILE && yum clean all && cp /usr/local/webhelpdesk/conf/whd.conf.orig /usr/local/webhelpdesk/conf/whd.conf && sed -i 's/^PRIVILEGED_NETWORKS=[[:space:]]*$/PRIVILEGED_NETWORKS=0.0.0.0\/0/g' /usr/local/webhelpdesk/conf/whd.conf
ADD run.sh /run.sh
ADD supervisord.conf /home/docker/whd/supervisord.conf
RUN chmod 744 /run.sh
EXPOSE 8081

ENTRYPOINT ["/run.sh"]

