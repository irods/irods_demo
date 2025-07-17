#!/bin/bash -x

su - irods -c 'irodsServer -d'

# wait for server to respond
CMD='echo -e "\x00\x00\x00\x33<MsgHeader_PI><type>HEARTBEAT</type></MsgHeader_PI>" | (exec 3<>/dev/tcp/127.0.0.1/1247; cat >&3; cat <&3; exec 3<&-)'
i=1
#echo "attempt ${i}"
STATUS=$(eval ${CMD})
#echo "STATUS = ${STATUS}"
while [ "${STATUS}" != "HEARTBEAT" -a ${i} -le 10 ] ; do
  sleep 1
  i=$((i + 1))
#  echo "attempt ${i}"
  STATUS=$(eval ${CMD})
#  echo "STATUS = ${STATUS}"
done

# create s3 resource
su - irods -c 'iadmin mkresc s3resc s3 irods-catalog-provider:/demobucket/thevault "S3_DEFAULT_HOSTNAME=minio:19000;S3_AUTH_FILE=/var/lib/irods/s3.keypair;S3_REGIONNAME=us-east-1;S3_RETRY_COUNT=1;S3_WAIT_TIME_SECONDS=3;S3_PROTO=HTTP;ARCHIVE_NAMING_POLICY=consistent;HOST_MODE=cacheless_attached"'

cat /var/run/irods/irods-server.pid
ps -F -p $(cat /var/run/irods/irods-server.pid)
sleep 3
kill -TERM $(cat /var/run/irods/irods-server.pid)
echo $?
ps -F -p $(cat /var/run/irods/irods-server.pid)
#rm -f /var/run/irods/irods-server.pid
#echo $?
#cat /var/run/irods/irods-server.pid
#ps -p $(cat /var/run/irods/irods-server.pid)

#echo "last line of first run"
