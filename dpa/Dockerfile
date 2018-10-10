FROM centos:latest

LABEL ProductDownloadName="SolarWinds-DPA-10.2.579-64bit-Eval.tar.gz" Version="10.2.579" ProductName="DPA"

ENV VERSION=12.0.3074 VERSION_=12_0_3074 GZIP_FILE=dpa.tar.gz

RUN yum clean all && yum install -y python-setuptools jre wget && easy_install supervisor \
 && wget --progress=dot:mega http://downloads.solarwinds.com/solarwinds/Release/DatabasePeformanceAnalyzer-DPA/${VERSION}/SolarWinds-DPA-${VERSION}-64bit-Eval.tar.gz -O /$GZIP_FILE \
 && mkdir /app /app-tmp \
 && cd /app-tmp \
 && tar zxvf /$GZIP_FILE \
 && /app-tmp/dpa_${VERSION_}_x64_installer/dpa_${VERSION_}_x64_installer.sh \
             --target /app-tmp -- --silent-install --install-dir /app \
 && cd /app && rm -rf /app-tmp

EXPOSE 8123 8124

ADD start.sh /start.sh

ENTRYPOINT ["/start.sh"]
