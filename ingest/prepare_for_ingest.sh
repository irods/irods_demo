#! /bin/bash
echo "starting redis-server service"
service redis-server start
echo "redis-server service started"

# Go to the directory with the virtualenv, activate, and prepare for celery worker
cd /
. rodssync/bin/activate
export CELERY_BROKER_URL=redis://127.0.0.1:6379/0
export PYTHONPATH=`pwd`

# authenticate as an iRODS user
export IRODS_ENVIRONMENT_FILE=/irods_environment.json
iinit rods

# start Celtery workers
celery -A irods_capability_automated_ingest.sync_task worker -l error -Q restart,path,file -c 2
