#
# iRODS Provider Image.
#
FROM ubuntu:16.04

# Install automated ingest and redis-server
RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y sudo wget lsb-release apt-transport-https python-pip redis-server curl

# Install icommands to create environment file
RUN wget -qO - https://packages.irods.org/irods-signing-key.asc | apt-key add -; \
    echo "deb [arch=amd64] https://packages.irods.org/apt/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/renci-irods.list; \
    apt-get update && \
    apt-get install -y irods-icommands
RUN mkdir /ingest
# Add environment file for client user
COPY irods_environment.json /ingest

# Add ingest event handler
COPY landing_zone_put_with_resc_name_image_metadata.py /ingest

# Create virtualenv for use in running ingest tool and install ingest
RUN pip install --upgrade pip && \
    pip install virtualenv && \
    virtualenv -p python3 rodssync && \
    . /rodssync/bin/activate && \
    pip install irods_capability_automated_ingest exifread

# Set command to execute when launching the container.
COPY prepare_for_ingest.sh /ingest
RUN chmod u+x /ingest/prepare_for_ingest.sh
#ENTRYPOINT ["./prepare_for_ingest.sh"]
RUN curl -fSL https://github.com/jwilder/dockerize/releases/download/v0.6.1/dockerize-linux-amd64-v0.6.1.tar.gz -o dockerize-linux-amd64-v0.6.1.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-v0.6.1.tar.gz
CMD dockerize -wait tcp://icat.example.org:1247 -timeout 250s /ingest/prepare_for_ingest.sh
