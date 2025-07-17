#! /bin/bash -e

unattended_install_file=/unattended_install.json
if [ -e "${unattended_install_file}" ]; then
    echo "Running iRODS setup"
    sed -i "s/THE_HOSTNAME/${HOSTNAME}/g" ${unattended_install_file}

    # unattended workaround for 5.0.1
    sed -i '/^\s*setup_server_host(irods_config)/s/^/    /' /var/lib/irods/scripts/setup_irods.py
    sed -i '/^\s*setup_server_host(irods_config)/{h;d;};/^\s*json_configuration_dict = None/{G;}' /var/lib/irods/scripts/setup_irods.py

    python3 /var/lib/irods/scripts/setup_irods.py --json_configuration_file ${unattended_install_file}
    rm ${unattended_install_file}
fi

echo "Starting server"

cd /usr/sbin
su irods -c 'irodsServer --stdout'
