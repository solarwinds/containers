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

FROM centos:7 AS builder

ENV WHD_VER 12.6.0
ENV WHD_BUILD 738-1
ENV WHD_RPM webhelpdesk.rpm
ENV WHD_HOME /usr/local/webhelpdesk

ADD ./scripts $WHD_HOME/scripts
ADD https://downloads.solarwinds.com/solarwinds/Release/WebHelpDesk/$WHD_VER/Linux/webhelpdesk-$WHD_VER.$WHD_BUILD.x86_64.rpm.gz /$WHD_RPM.gz

RUN ln -s /usr/sbin/ss /usr/bin/ss
RUN mkdir -p $WHD_HOME/bin/pgsql/var/lib/pgsql/9.2/data
RUN touch $WHD_HOME/bin/pgsql/var/lib/pgsql/9.2/data/pg_hba.conf
RUN echo "NETWORKING=yes" >/etc/sysconfig/network

RUN gzip -d /$WHD_RPM.gz
RUN yum clean all && yum update -y
RUN yum install -y python-setuptools
RUN yum install -y initscripts
RUN yum install epel-release -y
RUN yum install jq -y
RUN easy_install supervisor
RUN yum install -y -v /$WHD_RPM
RUN cp $WHD_HOME/conf/whd.conf.orig $WHD_HOME/conf/whd.conf 
RUN sed -i 's/^PRIVILEGED_NETWORKS=[[:space:]]*$/PRIVILEGED_NETWORKS=0.0.0.0\/0/g' $WHD_HOME/conf/whd.conf
RUN chmod 755 $WHD_HOME/whd 
RUN chmod +x $WHD_HOME/scripts/*.sh
RUN chmod 755 $WHD_HOME/bin/whd
RUN rm -f /$WHD_RPM /$WHD_RPM.gz
RUN yum clean all

FROM centos:7

COPY --from=builder /etc /etc
COPY --from=builder /root/.pki /root/.pki
COPY --from=builder /run/netreport /run/netreport
COPY --from=builder /usr /usr
COPY --from=builder /var/lib /var/lib

EXPOSE 8081 8443

ENTRYPOINT ["/usr/local/webhelpdesk/scripts/entrypoint.sh"]