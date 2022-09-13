#! /bin/bash -e

echo "Waiting for database to be ready"

metalnx_db_hostname=irods_demo_metalnx-db_1
until pg_isready -h ${metalnx_db_hostname} -d IRODS-EXT -U metalnx -q
do
    sleep 1
done

echo "database is ready, waiting for iRODS to be ready"

irods_catalog_provider_hostname=irods_demo_irods-catalog-provider_1
until nc -z ${irods_catalog_provider_hostname} 1247
do
    sleep 1
done

# After setting up iRODS, the server will respond on port 1247. However, the server process is
# stopped after some preliminary tests are completed. The irods-catalog-provider service will
# start the server manually again, but this will take a few seconds. Sleep here to ensure that
# next time the server responds is not the temporary uptime provided during setup.
sleep 3

until nc -z ${irods_catalog_provider_hostname} 1247
do
    sleep 1
done

echo "iRODS is ready"

bash -c /runit.sh
