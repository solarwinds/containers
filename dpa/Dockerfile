# Version: 0.0.1

FROM centos:latest

MAINTAINER Solarwinds  "vijay.veeraraghavan@solarwinds.com"

LABEL ProductDownloadName="SolarWinds-DPA-10.2.579-64bit-Eval.tar.gz" Version="10.2.579" ProductName="DPA"

ENV PRODUCT_DOWNLOAD_DIR=10.2.579SR1 PRODUCT_DOWNLOAD_NAME=SolarWinds-DPA-10.2.579-64bit-Eval.tar.gz GZIP_FILE=dpa.tar.gz
   
ADD http://downloads.solarwinds.com/solarwinds/Release/DatabasePeformanceAnalyzer-DPA/$PRODUCT_DOWNLOAD_DIR/$PRODUCT_DOWNLOAD_NAME /$GZIP_FILE
ADD install.sh /install.sh
RUN yum clean all && yum install -y python-setuptools jre && easy_install supervisor  

ADD run.sh /run.sh

RUN chmod 744 /run.sh && chmod 744 /install.sh

ADD supervisord.conf /home/docker/dpa/supervisord.conf


EXPOSE 8123 8124

ENTRYPOINT ["/run.sh"]
#ENTRYPOINT ["/bin/bash"]

