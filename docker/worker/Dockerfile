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

FROM ubuntu:16.04
MAINTAINER Oleg Lodygensky (oleg.lodygensky@lal.in2p3.fr)
LABEL "copyrights"="CNRS 2016"
LABEL "author"="Oleg Lodygensky"
LABEL version="0.2"
LABEL description="This creates a Docker image for the XWHEP worker"

#
# DEBIAN_FRONTEND=noninteractive bypasses user input.
# Hence, mysql-server installation will not ask
# for the new mysql admin password;
# and mysql admin password will be empty
#
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive && apt-get install -y apt-utils
RUN export DEBIAN_FRONTEND=noninteractive && apt-get install -y openjdk-8-jdk zip unzip wget make ant gcc uuid uuid-runtime vim git

COPY xwhep-worker-10.5.0.deb /tmp/
RUN cd /tmp/ && dpkg -i xwhep-worker-10.5.0.deb
RUN service xtremweb.worker start
