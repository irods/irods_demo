FROM ubuntu:16.04

# Install pre-requisites
RUN apt-get update && \
    apt-get install -y apt-transport-https postgresql

RUN sed -i "s/#listen_addresses.*/listen_addresses = '\*'/" /etc/postgresql/*/main/postgresql.conf
RUN sed -i "/IPv4 local connections.*/a host    all             all             192.0.0.1/8             md5" /etc/postgresql/*/main/pg_hba.conf
RUN sed -i "/IPv4 local connections.*/a host    all             all             172.0.0.1/8             md5" /etc/postgresql/*/main/pg_hba.conf

# Setup catalog database
ADD db_commands.txt /
RUN service postgresql start && su - postgres -c 'psql -f /db_commands.txt'

RUN echo "#! /bin/bash\nservice postgresql start\ntail -f /dev/null" > /keep_alive.sh && chmod +x /keep_alive.sh
ENTRYPOINT ["/keep_alive.sh"]
