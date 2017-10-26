#!/bin/sh
###################################################
# Written By: Francois Branciard
# Purpose: update all app to public
# Oct 24, 2017
###################################################


XW_BIN_PATH="/home/vagrant/iexecdev/iexec-node/xtremweb-hep/build/dist/xwhep-11.2.0/bin"


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

if [ ! -d "${XW_BIN_PATH}" ]
then
    echo "XW_BIN_PATH ${XW_BIN_PATH} do not exist" >> ${LOG_FILE}
    exit 1
fi


if [ ! -f ${XW_BIN_PATH}/xwchmod ]
then
    echo "xwchmod file ${XW_BIN_PATH}/xwchmod do not exist" >> ${LOG_FILE}
    exit 1
fi



if [ $(ls ${SAS_DIR} | wc -l) -eq 0  ]
then
    echo "no app to update in SAS" >> ${LOG_FILE}
    exit 0
fi

if [ $(ls ${SAS_DIR} | wc -l) -gt 0  ]
then
    echo "apps found in SAS to update." >> ${LOG_FILE}
     for uidToTreat in $(ls ${SAS_DIR})
     do
        echo "treat ${uidToTreat}" >> ${LOG_FILE}
        ${XW_BIN_PATH}/xwchmod 0x755 ${uidToTreat}
        rc=$?;
        if [ $rc != 0 ]
        then
           echo "cannot change rights for uidToTreat : ${uidToTreat}" >> ${LOG_FILE}
           exit $rc;
        else
         echo " ${uidToTreat} updated. remove file from SAS" >> ${LOG_FILE}
         rm -f ${SAS_DIR}/${uidToTreat}
        fi
     done
     echo "all updates done. bye" >> ${LOG_FILE}
fi