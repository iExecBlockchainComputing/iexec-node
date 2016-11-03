#!/bin/sh

if [ -z "${OSTYPE##linux*}" ]; then
  DATE_FORMAT='--rfc-3339=seconds'
else
  DATE_FORMAT='+%Y-%m-%d %H:%M:%S%z'
fi

VERBOSE=''
ROOTDIR=`dirname $0`
XWHEPDIR="$ROOTDIR/xwhep-10.4.1"
XWSUBMIT="$XWHEPDIR/bin/xwsubmit"
XWRM="$XWHEPDIR/bin/xwrm"
XWRESULTS="$XWHEPDIR/bin/xwresults"
APPNAME="apptest"


#=============================================================================
#  Function  debug_message (Message part, ...)
#=============================================================================
debug_message ()
{
  echo "$(date "$DATE_FORMAT")  $0  DEBUG: " "$@"  > /dev/stderr
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
  
  echo "$(date "$DATE_FORMAT")  $0  FATAL:  ${*:-Ctrl+C}"  > /dev/stderr
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

trap fatal SIGINT SIGTERM


while [ $# -gt 0 ]
do
    case "$1" in
        -v | --verbose | --debug )
            VERBOSE=1
            ;;
    esac
    shift
done


[ -z "$VERBOSE" ]  || echo "$XWSUBMIT $APPNAME"
JOBURI=`$XWSUBMIT $APPNAME` || fatal "Can't submit job for $APPNAME"
[ -z "$VERBOSE" ]  || echo $JOBURI
JOBUID=$(echo "$JOBURI"  |  grep '^xw://'  |  sed -e 's=^.*/==')

while (true) ; do
    
  XMLCONTENT=`$XWRESULTS --xwformat xml $JOBURI`
  [ -z "$VERBOSE" ]  || echo "XML    = $XMLCONTENT"
  extract_xw_attribute_value "status" "$XMLCONTENT"
  XWSTATUS=$XW_ATTRIBUTE_VALUE

  echo "$JOBURI :  $XWSTATUS"

  if [ "$XWSTATUS" = "ERROR" ]; then
     $XWRM $JOBURI
     fatal $XWSTATUS
  fi

  [ "$XWSTATUS" = "COMPLETED" ] && break

  sleep 30

done

rm -f *${JOBUID}*
