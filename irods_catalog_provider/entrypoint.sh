#! /bin/bash -e

catalog_db_hostname=irods-catalog

echo "Waiting for iRODS catalog database to be ready"

until pg_isready -h ${catalog_db_hostname} -d ICAT -U irods -q
do
    sleep 1
done

echo "iRODS catalog database is ready"

unattended_install_file=/unattended_install.json
if [ -e "${unattended_install_file}" ]; then
    echo "Running iRODS setup"
    sed -i "s/THE_HOSTNAME/${HOSTNAME}/g" ${unattended_install_file}
    python3 /var/lib/irods/scripts/setup_irods.py --json_configuration_file ${unattended_install_file}
    rm ${unattended_install_file}
fi

echo "Starting server"

cd /usr/sbin
su irods -c 'bash -c "./irodsServer -u"'
