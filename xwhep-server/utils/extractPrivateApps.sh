#!/bin/sh
###################################################
# Written By: Francois Branciard
# Purpose: update all app to public
# Oct 26, 2017
###################################################

WORK_DIR=/tmp/updateAppsToPublic
LOG_FILE=/tmp/updateAppsToPublic/updateAppsToPublic.log
SAS_DIR=/tmp/updateAppsToPublic/SAS

mkdir -p ${WORK_DIR}
rc=$?;
if [ $rc != 0 ]
then
   echo "cannot create WORK_DIR : ${WORK_DIR}" >> ${LOG_FILE}
   exit $rc;
fi

mkdir -p ${SAS_DIR}
rc=$?;
if [ $rc != 0 ]
then
   echo "cannot create WORK_DIR : ${SAS_DIR}" >> ${LOG_FILE}
   exit $rc;
fi


TIME_SUFFIX=$(date +'%s')
touch ${WORK_DIR}/selectResult_${TIME_SUFFIX}
mysql -u ...... --password=..... .......  < selectAppsUid.sql > ${WORK_DIR}/selectResult_${TIME_SUFFIX}

if [ $( cat ${WORK_DIR}/selectResult_${TIME_SUFFIX} | wc -l ) -gt 0 ]
then
echo " do it" >> ${LOG_FILE}
sed -i '/^$/d' ${WORK_DIR}/selectResult_${TIME_SUFFIX}

while read uidToCheck
do

if [ -f ${SAS_DIR}/${uidToCheck} ]
then
        echo "uid ${uidToCheck} already in SAS. do nothing" >> ${LOG_FILE}
else
        echo "create ${uidToCheck} file in SAS" >> ${LOG_FILE}
        touch ${SAS_DIR}/${uidToCheck}
fi

done < ${WORK_DIR}/selectResult_${TIME_SUFFIX}

else

echo "all apps are public in db. nothing to do"  >> ${LOG_FILE}

fi

rm -f ${WORK_DIR}/selectResult_${TIME_SUFFIX}