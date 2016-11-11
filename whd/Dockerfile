# Version: 12.4.2
FROM centos:latest
MAINTAINER Vijay Veera "vijay.veeraraghavan@solarwinds.com"

ENV CONSOLETYPE serial

ADD functions /etc/rc.d/init.d/functions 
ADD http://downloads.solarwinds.com/solarwinds/Release/WebHelpDesk/12.4.2/Linux/webhelpdesk-12.4.2.36-1.x86_64.rpm.gz /webhelpdesk.rpm.gz 

RUN gunzip -dv /webhelpdesk.rpm.gz && yum clean all && yum update -y && yum install -y python-setuptools && easy_install supervisor && yum install -y -v /webhelpdesk.rpm  && rm /webhelpdesk.rpm && yum clean all && cp /usr/local/webhelpdesk/conf/whd.conf.orig /usr/local/webhelpdesk/conf/whd.conf && sed -i 's/^PRIVILEGED_NETWORKS=[[:space:]]*$/PRIVILEGED_NETWORKS=0.0.0.0\/0/g' /usr/local/webhelpdesk/conf/whd.conf 

ADD run.sh /run.sh 
ADD supervisord.conf /home/docker/whd/supervisord.conf

EXPOSE 8081

ENTRYPOINT ["/run.sh"] 
