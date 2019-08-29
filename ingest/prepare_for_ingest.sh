#! /bin/bash
echo "starting redis-server service"
service redis-server start
echo "redis-server service started"

# Go to the directory with the virtualenv, activate, and prepare for celery worker
cd /ingest
. /rodssync/bin/activate
export CELERY_BROKER_URL=redis://127.0.0.1:6379/0
export PYTHONPATH=`pwd`

# authenticate as an iRODS user
export IRODS_ENVIRONMENT_FILE=/ingest/irods_environment.json
iinit rods

# start Celery workers
celery -A irods_capability_automated_ingest.sync_task worker -l error -Q restart,path,file -c 4 &

imkdir landing_zone_collection
python -m irods_capability_automated_ingest.irods_sync start /tmp/landing_zone /tempZone/home/rods/landing_zone_collection --log_level INFO --log_filename /ingest/ingest.log --event_handler landing_zone_put_with_resc_name_image_metadata -i 1

# Keep the container up forever
tail -f /dev/null
