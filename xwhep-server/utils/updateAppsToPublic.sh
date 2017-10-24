#!/bin/sh
###################################################
# Written By: Francois Branciard
# Purpose: update all app to public
# Oct 24, 2017
###################################################


XW_BIN_PATH="/home/vagrant/iexecdev/iexec-node/xtremweb-hep/build/dist/xwhep-11.2.0/bin"

WORK_DIR=/tmp/updateAppsToPublic
UPDATED_APP_UID_FILE=/tmp/updateAppsToPublic/updated.txt
APP_UID_TO_UPDATE_FILE=/tmp/updateAppsToPublic/toupdate.txt


mkdir -p ${WORK_DIR}
rc=$?;
if [ $rc != 0 ]
then
   echo "cannot create WORK_DIR : ${WORK_DIR}"
   exit $rc;
fi

if [ ! -d "${XW_BIN_PATH}" ]
then
    echo "XW_BIN_PATH ${XW_BIN_PATH} do not exist"
    exit 1
fi

if [ ! -f ${XW_BIN_PATH}/xwapps ]
then
    echo "xwapps file ${XW_BIN_PATH}/xwapps do not exist"
    exit 1
fi


if [ ! -f ${XW_BIN_PATH}/xwchmod ]
then
    echo "xwchmod file ${XW_BIN_PATH}/xwchmod do not exist"
    exit 1
fi

rm -f ${WORK_DIR}/currentApps.tmp
${XW_BIN_PATH}/xwapps | grep UID >  ${WORK_DIR}/currentApps.tmp

if [ $(cat ${WORK_DIR}/currentApps.tmp | wc -l) -eq 0  ]
then
    echo "no apps. nothing to do"
    exit 0
fi

if [ $(cat ${WORK_DIR}/currentApps.tmp | wc -l) -gt 0  ]
then
    echo "apps found. check if chmod updated needed "
    #UID='5aa967ee-6aba-47ce-b0da-d1dd3d65d897', NAME='ls'
    cat ${WORK_DIR}/currentApps.tmp | awk -v FS="(UID='|', NAME)" '{print $2}' >${WORK_DIR}/currentAppsUID.tmp
    rm -f ${APP_UID_TO_UPDATE_FILE}
    if [ -f ${UPDATED_APP_UID_FILE} ] && [ $(cat ${UPDATED_APP_UID_FILE} | wc -l) -gt 0 ]
    then
        echo "check only new UID"
        sort ${WORK_DIR}/currentAppsUID.tmp -o ${WORK_DIR}/currentAppsUID.tmp
        sort ${UPDATED_APP_UID_FILE} -o ${UPDATED_APP_UID_FILE}
        # comm -3  = suppress column 3 (lines that appear in both files)
        comm -3 --check-order ${WORK_DIR}/currentAppsUID.tmp ${UPDATED_APP_UID_FILE} | tr -d '\t' > ${APP_UID_TO_UPDATE_FILE}
    else
          echo "treat all UID found"
          cat ${WORK_DIR}/currentAppsUID.tmp > ${APP_UID_TO_UPDATE_FILE}
    fi
      if [ -f ${APP_UID_TO_UPDATE_FILE} ] && [ $(cat ${APP_UID_TO_UPDATE_FILE}| wc -l) -gt 0 ]
        then
             echo "UIDs to treat : "
             echo "----------${APP_UID_TO_UPDATE_FILE}---------------"
             cat ${APP_UID_TO_UPDATE_FILE}
             echo "-------------------------"
             for uidToTreat in $(cat ${APP_UID_TO_UPDATE_FILE})
             do
                echo "treat ${uidToTreat}"
                ${XW_BIN_PATH}/xwchmod 0x755 ${uidToTreat}
                rc=$?;
                if [ $rc != 0 ]
                then
                   echo "cannot change rights for uidToTreat : ${uidToTreat}"
                   exit $rc;
                else
                  echo ${uidToTreat} >> ${UPDATED_APP_UID_FILE}
                fi
             done
             echo "all done. bye bye"
             exit 0
        else
            echo "nothing to do"
            exit 0
        fi
fi