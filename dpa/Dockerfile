FROM centos:centos8

LABEL ProductDownloadName="SolarWinds-DPA-2021.1.775-64bit.tar.gz" Version="2021.1.775" ProductName="DPA"

ENV VERSION=2021.1.775 VERSION_=2021_1_775 GZIP_FILE=dpa.tar.gz
RUN yum clean all && yum install -y jre wget \
 && wget --progress=dot:mega http://downloads.solarwinds.com/solarwinds/Release/DatabasePeformanceAnalyzer-DPA/${VERSION}/SolarWinds-DPA-${VERSION}-64bit.tar.gz -O /$GZIP_FILE \
 && mkdir /app /app-tmp \
 && cd /app-tmp \
 && tar zxvf /$GZIP_FILE \
 && /app-tmp/dpa_${VERSION_}_x64_installer/dpa_${VERSION_}_x64_installer.sh \
             --target /app-tmp -- --silent-install --install-dir /app \
 && cd /app && rm -rf /app-tmp

EXPOSE 8123 8124

ADD start.sh /start.sh

ENTRYPOINT ["/start.sh"]
