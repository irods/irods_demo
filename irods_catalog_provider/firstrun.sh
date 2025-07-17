#!/bin/bash

su - irods -c 'irodsServer -d'

# wait for server to respond
until nc -z irods-catalog-provider 1247
do
    sleep 1
done

# create s3 resource
su - irods -c 'iadmin mkresc s3resc s3 irods-catalog-provider:/demobucket/thevault "S3_DEFAULT_HOSTNAME=minio:19000;S3_AUTH_FILE=/var/lib/irods/s3.keypair;S3_REGIONNAME=us-east-1;S3_RETRY_COUNT=1;S3_WAIT_TIME_SECONDS=3;S3_PROTO=HTTP;ARCHIVE_NAMING_POLICY=consistent;HOST_MODE=cacheless_attached"'

# wait for any other services to see this service is healthy
sleep 2
