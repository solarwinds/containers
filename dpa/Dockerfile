# Copyright 2016 SolarWinds Worldwide, LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM centos:latest

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
