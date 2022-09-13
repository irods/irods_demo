#! /bin/bash -e

/etc/init.d/rsyslog start

/etc/init.d/irods_client_rest_cpp start

# sleep forever
until false; do sleep 2147483647d; done
