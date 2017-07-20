#
#  Copyrights     : CNRS
#  Author         : Oleg Lodygensky
#  Acknowledgment : XtremWeb-HEP is based on XtremWeb 1.8.0 by inria : http://www.xtremweb.net/
#  Web            : http://www.xtremweb-hep.org
#   
#  This file is part of XtremWeb-HEP.
# 
#  XtremWeb-HEP is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
# 
#  XtremWeb-HEP is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
# 
#  You should have received a copy of the GNU General Public License
#  along with XtremWeb-HEP.  If not, see <http://www.gnu.org/licenses/>.
#
#

# Versionning
#  0.3 : July 7th, 2017
#    a) xwversion : 10.6.0
#    b) exposes server ports
#

FROM ubuntu:16.04
MAINTAINER Oleg Lodygensky (oleg.lodygensky@lal.in2p3.fr)
LABEL "copyrights"="CNRS 2016"
LABEL "author"="Oleg Lodygensky"
LABEL version="0.3"
LABEL description="This downloads and compiles XWHEP server"
EXPOSE 4320 4321 4322 4323 4324 4325 4326 4327 4328 4329

ENV XWVERSION "10.6.0"

# next is only to check file is present
# before getting time to apt-get update etc.
COPY xwconfigure.values /tmp/

#
# DEBIAN_FRONTEND=noninteractive bypasses user input.
# Hence, mysql-server installation will not ask
# for the new mysql admin password;
# and mysql admin password will be empty
#
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive && apt-get install -y apt-utils
RUN export DEBIAN_FRONTEND=noninteractive && apt-get install -y openjdk-8-jdk mysql-server mysql-client zip unzip wget make ant gcc uuid uuid-runtime vim git
#RUN service mysql start
RUN cd /root && wget https://github.com/lodygens/xtremweb-hep/archive/master.zip
RUN cd /root && unzip master.zip
# RUN cd /root & git clone https://github.com/lodygens/xtremweb-hep.git
RUN export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/ && cd /root/xtremweb-hep-master/build/ && make clean && make

COPY xwconfigure.values /root/xtremweb-hep-master/build/dist/xwhep-$XWVERSION/conf/
RUN service mysql start && export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/ && cd /root/xtremweb-hep-master/build/dist/xwhep-$XWVERSION/  && ./bin/xwconfigure --yes || ./bin/xwconfigure --yes

RUN cd /root/xtremweb-hep-master/build/dist/xwhep-$XWVERSION/  && dpkg -i xwhep-server-$XWVERSION.deb && dpkg -i xwhep-server-conf-$XWVERSION.deb 

#
# -1- don't renice in container
# -2- we must remove LAUNCHERURL since Apache is not installed
# 
RUN sed -i "s/^V_NICE=.*//g" /opt/xwhep-server-$XWVERSION/bin/xtremwebconf.sh
RUN sed -i "s/LAUNCHER.*//g" /opt/xwhep-server-$XWVERSION/conf/xtremweb.server.conf

#
# Entry point script
# 
RUN echo "#!/bin/sh" > /tmp/xwstart.sh
RUN echo "service mysql start" >> /tmp/xwstart.sh
RUN echo "/etc/init.d/xtremweb.server console" >> /tmp/xwstart.sh
RUN chmod +x /tmp/xwstart.sh

ENTRYPOINT [ "/tmp/xwstart.sh" ]

