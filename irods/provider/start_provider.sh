#! /bin/bash

# Start the Postgres database.
service postgresql start
counter=0
until pg_isready -q
do
    sleep 1
    ((counter += 1))
done
echo Postgres took approximately $counter seconds to fully start ...

# Set up iRODS.
if [ ! -e /var/lib/irods/VERSION.json ]; then
python /var/lib/irods/scripts/setup_irods.py < /var/lib/irods/packaging/localhost_setup_postgres.input
pkill irodsServer
fi
sudo -iu irods bash -c "cd /usr/sbin; ./irodsServer -u"

# Keep container running if the test fails.
#tail -f /dev/null
# Is this better? sleep 2147483647d

