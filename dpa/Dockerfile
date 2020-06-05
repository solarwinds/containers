FROM centos:centos8

LABEL ProductDownloadName="SolarWinds-DPA-2020.2.690-64bit-Eval.tar.gz" Version="2020.2.690" ProductName="DPA"

ENV VERSION=2020.2.690 VERSION_=2020_2_690 GZIP_FILE=dpa.tar.gz
RUN yum clean all && yum install -y jre wget \
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
