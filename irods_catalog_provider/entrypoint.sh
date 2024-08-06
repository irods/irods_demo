#! /bin/bash -e

catalog_db_hostname=irods-catalog

echo "Waiting for iRODS catalog database to be ready"

until pg_isready -h ${catalog_db_hostname} -d ICAT -U irods -q
do
    sleep 1
done

echo "iRODS catalog database is ready"

setup_input_file=/irods_setup.input

if [ -e "${setup_input_file}" ]; then
    echo "Running iRODS setup"
    python3 /var/lib/irods/scripts/setup_irods.py < "${setup_input_file}"
    rm /irods_setup.input
fi

echo "Starting rsyslog"

rsyslogd

echo "Starting iRODS server"

su - irods -c './irodsctl -v start'

# Used by the healthcheck to determine when the server is ready to accept requests.
touch /irods_ready.flag

# To view the log files of the iRODS server, tail /var/log/irods/irods.log while
# inside the container or by using "docker exec".

# Keep the container alive by sleeping forever.
while true; do sleep 2147483647d; done
