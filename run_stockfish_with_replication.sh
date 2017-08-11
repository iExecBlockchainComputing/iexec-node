#!/bin/sh

if [ -z "${OSTYPE##linux*}" ]; then
	DATE_FORMAT='--rfc-3339=seconds'
else
	DATE_FORMAT='+%Y-%m-%d %H:%M:%S%z'
fi

VERBOSE=''
RESULTURI=''
ROOTDIR=`dirname $0`
XWHEPDIR="$ROOTDIR/xwhep-10.5.1"
XWBIN="$XWHEPDIR/bin"
XWSUBMIT="$XWBIN/xwsubmit"
XWRM="$XWBIN/xwrm"
XWRESULTS="$XWBIN/xwresults"
XWWORKS="$XWBIN/xwworks"
XWGROUPWORKS="$XWBIN/xwgroupworks"
XWDOWNLOAD="$XWBIN/xwdownload"
XWSENDGROUP="$XWBIN/xwsendgroup"
APPNAME="stockfish"
STDIN=""


GROUPLABEL=`date "+%s"`



#=============================================================================
#  Function  debug_message (Message part, ...)
#=============================================================================
debug_message ()
{
	echo "$(date "$DATE_FORMAT")  $0  DEBUG: " "$@"
}


#=============================================================================
#  Function  info_message (Message part, ...)
#=============================================================================
info_message ()
{
	echo "$(date "$DATE_FORMAT")  $0  INFO: " "$@"
}


#=============================================================================
#  Function  fatal (Message part, ...)
#=============================================================================
fatal ()
{
	RC=$?
	if [ $RC -eq 0 ]; then RC=1; fi

	echo "$(date "$DATE_FORMAT")  $0  FATAL:  ${*:-Ctrl+C}"
	exit $RC
}


#=============================================================================
#  Function  extract_xw_attribute_value (attr_name, xml_content)
#=============================================================================
extract_xw_attribute_value ()
{
	XW_ATTRIBUTE_NAME="$1"
	XW_XML="$2"

	XW_ATTRIBUTE_VALUE=$(perl -we  \
		'if ( $ARGV[0] =~ /(<'"$XW_ATTRIBUTE_NAME"'>)(.*)(<\/'"$XW_ATTRIBUTE_NAME"'>)/i )
	{print $2}'  "$XW_XML")
		[ "$XW_ATTRIBUTE_VALUE" ]  ||  \
			fatal  "Can NOT extract '$XW_ATTRIBUTE_NAME' of $XW_DESCRIPTION from"  \
			"'$XW_XML'"
}



#=============================================================================
#  Main
#=============================================================================

#trap 'fatal' SIGINT SIGTERM


#while [ $# -gt 0 ]
#do
#    case "$1" in
#        -v | --verbose | --debug )
#            VERBOSE=1
#            ;;
#    esac
#    shift
#done

[ -z $1 ] || STDIN=$1

#VERBOSE=1
GROUPURI=$($XWSENDGROUP $GROUPLABEL | grep -E "^xw")  || fatal "Can't create group"
[ -z "$VERBOSE" ]  || echo "Group URI    = $GROUPURI"
GROUPUID=$(echo "$GROUPURI"  |  grep '^xw://'  |  sed -e 's=^.*/==')
[ -z "$VERBOSE" ]  || echo "Group UID    = $GROUPUID"
TMPFILE="/tmp/$GROUPUID"

JOBURI=`$XWSUBMIT $APPNAME --xwgroup $GROUPUID --xwreplica 30 --xwreplicasize 10 --xwstdin $STDIN` || fatal "Can't submit job for $APPNAME"
[ -z "$VERBOSE" ]  || echo "Job UID $JOBURI"
JOBUID=$(echo "$JOBURI"  |  grep '^xw://'  |  sed -e 's=^.*/==')

while (true) ; do

	$XWGROUPWORKS $GROUPUID > $TMPFILE
	[ -z "$VERBOSE" ]  || cat $TMPFILE

	#
	# we stop if one is in ERROR
	#
	cat $TMPFILE | grep ERROR >> /dev/null 2>&1
	if [ $? -eq 0 ]; then
		$XWRM $GROUPURI
		fatal "Group work ERROR"
	fi


	#
	# we stop if one is COMPLETED
	#
	COMPLETEDJOBUID=$(cat $TMPFILE | grep "STATUS='COMPLETED'" | head -1 | cut -d '=' -f 2 | cut -d ',' -f 1 | sed "s/'//g")
	if [ ! -z "$COMPLETEDJOBUID" ] ; then
		[ -z "$VERBOSE" ]  || echo "Completed UID = $COMPLETEDJOBUID"
		XMLCONTENT=`$XWWORKS --xwformat xml $COMPLETEDJOBUID`
		[ -z "$VERBOSE" ]  || echo "XML    = $XMLCONTENT"
		extract_xw_attribute_value "resulturi" "$XMLCONTENT"
		RESULTURI=$XW_ATTRIBUTE_VALUE
		RESULTUID=$(echo "$RESULTURI"  |  grep '^xw://'  |  sed -e 's=^.*/==')
	        echo "COMPLETED"
		break
	fi

	echo "RUNNING"
	sleep 30

done

cd /home/ubuntu

[ -z "$VERBOSE" ]  || echo "RESULTURI    = $RESULTURI"
if [ ! -z "$RESULTURI" ] ; then
    $XWWORKS $COMPLETEDJOBUID || echo "Status error"
    $XWDOWNLOAD $RESULTURI >> /dev/null 2>&1|| echo "Download error"
else
	echo "No result to download"
fi
mkdir -p ${COMPLETEDJOBUID}
RESULTZIPFILENAME="${RESULTUID}_ResultsOf_${COMPLETEDJOBUID}.zip"
[ -f ${RESULTZIPFILENAME} ] && mv ${RESULTZIPFILENAME}* ${COMPLETEDJOBUID}/
[ -f *${RESULTUID}* ] && mv *${RESULTUID}* ${COMPLETEDJOBUID}/
cd ${COMPLETEDJOBUID}
pwd
[ -z "$VERBOSE" ]  || ls -l
[ -f ${RESULTZIPFILENAME} ] && unzip -o ${RESULTZIPFILENAME} >> /dev/null 2>&1
[ -f ${RESULTZIPFILENAME} ] && rm -f ${RESULTZIPFILENAME}
[ -f *stdout* ] && cat *stdout*
[ -f *stderr* ] && cat *stderr*

cd ..

#[ -z "$VERBOSE" ]  && $XWRM $GROUPURI
#[ -z "$VERBOSE" ]  && rm -Rf ${COMPLETEDJOBUID}

