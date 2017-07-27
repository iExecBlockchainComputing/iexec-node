#!/bin/sh
#=============================================================================
#
#  File    : docker.sh
#  Date    : July 25th, 2017
#  Author  : Oleg Lodygensky
#
#  Change log:
#  - Jul 24th,2017 : Oleg Lodygensky; creation
#
#  OS      : Linux, mac os x
# 
#  Purpose : this script creates and starts a new XWHEP plaftorm
#
#=============================================================================


# Copyrights     : CNRS
# Author         : Oleg Lodygensky
# Acknowledgment : XtremWeb-HEP is based on XtremWeb 1.8.0 by inria : http://www.xtremweb.net/
# Web            : http://www.xtremweb-hep.org
# 
#      This file is part of XtremWeb-HEP.
#
#    XtremWeb-HEP is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    XtremWeb-HEP is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with XtremWeb-HEP.  If not, see <http://www.gnu.org/licenses/>.
#
#


THISOS=`uname -s`

case "$THISOS" in
  
  Darwin )
    DATE_FORMAT='+%Y-%m-%d %H:%M:%S%z'
    ;;
  
  Linux )
    DATE_FORMAT='--rfc-3339=seconds'
    ;;
  
  * )
    fatal  "OS not supported ($THISOS)"  TRUE
    ;;
  
esac

#=============================================================================
#
#  Function  fatal (Message)
#
#=============================================================================
fatal ()
{
  msg="$1"
  [ "$msg" ]  ||  msg="Ctrl+C"
  
  echo  "$(date "$DATE_FORMAT")  $SCRIPTNAME  FATAL : $msg"
  docker kill ${CONTAINERNAME_SERVER}
  docker rm   ${CONTAINERNAME_SERVER}
  
  exit 1
}

#=============================================================================
#
#  Function  fatal (Message)
#
#=============================================================================
warn ()
{
  msg="$1"
  [ "$msg" ]  ||  msg="Ctrl+C"
  
  echo  "$(date "$DATE_FORMAT")  $SCRIPTNAME  WARNING : $msg"
}

#=============================================================================
#
#  Function  usage ()
#
#=============================================================================
usage()
{
cat << END_OF_USAGE
  This script deploy an XWHEP platform.
  XWHEP server, worker and client images must be available.
  Please refer to docker/server-master.
END_OF_USAGE

  exit 0
}


#=============================================================================
#
#  Main
#
#=============================================================================
trap  fatal  SIGINT  SIGTERM



ROOTDIR="$(dirname "$0")"
SCRIPTNAME="$(basename "$0")"

type docker > /dev/null 2>&1
if [ $? -ne 0 ] ; then
	fatal "docker not installed"
fi
type docker-compose > /dev/null 2>&1
if [ $? -ne 0 ] ; then
	fatal "docker-compose not installed"
fi


XWSERVERHEADERNAME="xwserver"
XWWORKERHEADERNAME="xwworker"
XWCLIENTHEADERNAME="xwclient"

XWSERVERHOSTNAME=${XWSERVERHEADERNAME}
XWWORKERHOSTNAME=${XWWORKERHEADERNAME}
XWCLIENTHOSTNAME=${XWCLIENTHEADERNAME}


while [ $# -gt 0 ]; do
  
  case "$1" in
  
    --help )
      usage
      ;;
    
    -v | --verbose | --debug )
      VERBOSE=1
      set -x
      ;;

  esac

  shift

done
 

docker images | grep ${XWSERVERHEADERNAME} > /dev/null 2>&1
[ $? -ne 0 ] && fatal "Can't find any server image"
docker images | grep ${XWWORKERHEADERNAME}> /dev/null 2>&1
[ $? -ne 0 ] && fatal "Can't find any worker image"
docker images | grep ${XWCLIENTHEADERNAME} > /dev/null 2>&1
[ $? -ne 0 ] && fatal "Can't find any client image"

NBSERVERS=$(docker images | grep ${XWSERVERHEADERNAME} | wc -l)
NBWORKERS=$(docker images | grep ${XWWORKERHEADERNAME} | wc -l)
NBCLIENTS=$(docker images | grep ${XWCLIENTHEADERNAME} | wc -l)

IMAGENAME_SERVER=$(docker images | grep ${XWSERVERHEADERNAME} | cut -d ' ' -f 1 | tail -1 )
IMAGENAME_WORKER=$(docker images | grep ${XWWORKERHEADERNAME} | cut -d ' ' -f 1 | tail -1 )
IMAGENAME_CLIENT=$(docker images | grep ${XWCLIENTHEADERNAME} | cut -d ' ' -f 1 | tail -1 )

XWJOBUID="$(date '+%Y-%m-%d-%H-%M-%S')"

CONTAINERNAME_SERVER="xwservercontainer_${XWJOBUID}"
CONTAINERNAME_WORKER="xwworkercontainer_${XWJOBUID}"
CONTAINERNAME_CLIENT="xwclientcontainer_${XWJOBUID}"

SERVERLOGFILE=${ROOTDIR}/${CONTAINERNAME_SERVER}.log
WORKERLOGFILE=${ROOTDIR}/${CONTAINERNAME_WORKER}.log


[ ${NBSERVERS} -gt 1 ] && warn "There is more than one server image; will use ${IMAGENAME_SERVER}"
[ ${NBWORKERS} -gt 1 ] && warn "There is more than one worker image; will use ${IMAGENAME_WORKER}"
[ ${NBCLIENTS} -gt 1 ] && warn "There is more than one client image; will use ${IMAGENAME_CLIENT}"

docker run --name=${CONTAINERNAME_SERVER} --hostname=${XWSERVERHOSTNAME}  ${IMAGENAME_SERVER} > ${SERVERLOGFILE} 2>&1 &

sleep 10

NETWORKID=$(docker inspect ${CONTAINERNAME_SERVER} | grep NetworkID | cut -d ':' -f 2 | sed "s/\"//g"| sed "s/,//g")
SERVERIPADDR=$(docker inspect ${CONTAINERNAME_SERVER} | grep -v SecondaryIPAddresses | grep IPAddress | cut -d ':' -f 2 | sed "s/\"//g"| sed "s/,//g"| tail -1)

#docker run -ti --network=${NETORKID} --hostname=${XWWORKERHOSTNAME} --env XWSERVERADDR="${SERVERIPADDR}"  --name ${CONTAINERNAME_WORKER} ${IMAGENAME_WORKER} /bin/bash

docker run -ti --network=${NETORKID} --hostname=${XWCLIENTHOSTNAME} --env XWSERVERADDR="${SERVERIPADDR}"  --name ${CONTAINERNAME_CLIENT} ${IMAGENAME_CLIENT} /bin/bash

exit 0
###########################################################
#     EOF        EOF     EOF        EOF     EOF       EOF #
###########################################################
