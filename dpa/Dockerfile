FROM centos:latest

# LABEL ProductDownloadName="SolarWinds-DPA-10.2.579-64bit-Eval.tar.gz" Version="10.2.579" ProductName="DPA"

ENV GZIP_FILE=dpa.tar.gz PREFIX=dpa_12_1_696 VERSION=12.1.696

# Resources from remote URLs are not auto decompressed
ADD https://downloads.solarwinds.com/solarwinds/Release/DatabasePeformanceAnalyzer-DPA/${VERSION}/SolarWinds-DPA-${VERSION}-64bit-Eval.tar.gz /${GZIP_FILE}

RUN \
  yum clean all && \
  yum install -y python-setuptools urw-fonts && \
  easy_install supervisor && \
  mkdir /app /app-tmp && \
  cd /app-tmp && \
  tar xf /${GZIP_FILE} && \
  /app-tmp/${PREFIX}_x64_installer/${PREFIX}_x64_installer.sh --target /app-tmp -- --silent-install --install-dir /app && \
  cd /app && \
  rm -rf /app-tmp

EXPOSE 8123 8124

ADD start.sh /start.sh

ENTRYPOINT ["/start.sh"]
