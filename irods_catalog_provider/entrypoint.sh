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

    # unattended workaround for 5.0.1
    sed -i '/^\s*setup_server_host(irods_config)/s/^/    /' /var/lib/irods/scripts/setup_irods.py
    sed -i '/^\s*setup_server_host(irods_config)/{h;d;};/^\s*json_configuration_dict = None/{G;}' /var/lib/irods/scripts/setup_irods.py

    python3 /var/lib/irods/scripts/setup_irods.py --json_configuration_file ${unattended_install_file}
    rm ${unattended_install_file}

    echo "Running firstrun.sh"
    bash firstrun.sh
#    echo "first run complete"
#    ps aux
#    ps -F -p $(cat /var/run/irods/irods-server.pid)
#    echo "end of entrypoint if"
else
    echo "Starting server"
    cd /usr/sbin
    su irods -c 'irodsServer --stdout'
fi

#echo "Starting server"

