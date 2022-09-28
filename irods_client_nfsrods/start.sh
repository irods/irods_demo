#! /bin/bash

if [ "$1" != "sha" ]; then
    # Handle SSL/TLS cert.
    if [ -f /nfsrods_ssl.crt ]; then
       echo "Cert found for NFSRODS"
       set +e
       keytool -delete -noprompt -alias mycert -keystore /etc/ssl/certs/java/cacerts -storepass changeit
       set -e
       echo "Importing cert to OpenJDK keystore"
       keytool -import -trustcacerts -keystore /etc/ssl/certs/java/cacerts -storepass changeit -noprompt -alias mycert -file /nfsrods_ssl.crt
       echo "Done"
    else
       echo "Cert not found for NFSRODS - not importing"
    fi
fi

echo "waiting for iRODS to be ready"

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

exec java \
    -Dlog4j2.contextSelector=org.apache.logging.log4j.core.async.AsyncLoggerContextSelector \
    -Dlog4j2.configurationFile=$NFSRODS_CONFIG_HOME/log4j.properties \
    -Dlog4j.shutdownHookEnabled=false \
    -jar /nfsrods.jar "$@"
