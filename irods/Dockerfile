#
# iRODS Provider Image.
#
FROM ubuntu:18.04

# Install pre-requisites
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get install -y sudo wget lsb-release apt-transport-https postgresql vim python-pip libfuse2 unixodbc rsyslog less netcat && \
    pip install xmlrunner

# Setup catalog database
COPY db_commands.txt /
RUN service postgresql start && su - postgres -c 'psql -f /db_commands.txt'

# Install iRODS
RUN wget -qO - https://packages.irods.org/irods-signing-key.asc | apt-key add -; \
    echo "deb [arch=amd64] https://packages.irods.org/apt/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/renci-irods.list; \
    apt-get update
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get install -y irods-runtime=4.2.8 irods-icommands=4.2.8 irods-server=4.2.8 irods-database-plugin-postgres=4.2.8 irods-rule-engine-plugin-audit-amqp=4.2.8.0 irods-rule-engine-plugin-update-collection-mtime=4.2.8.0 irods-rule-engine-plugin-unified-storage-tiering=4.2.8.0
COPY configure_audit_plugin.py /var/lib/irods/scripts/
COPY configure_update_collection_mtime_plugin.py /var/lib/irods/scripts/
COPY configure_unified_storage_tiering_plugin.py /var/lib/irods/scripts/
COPY configure_users.py /var/lib/irods/scripts/

EXPOSE 1248 1247

# Set command to execute when launching the container.
COPY start_provider.sh /
RUN chmod u+x /start_provider.sh
ENTRYPOINT ["./start_provider.sh"]
