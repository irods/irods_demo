FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
        apt-transport-https \
        gnupg \
        wget \
        netcat-traditional \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/*

RUN wget -qO - https://packages.irods.org/irods-signing-key.asc | apt-key add - && \
    echo "deb [arch=amd64] https://packages.irods.org/apt/ noble main" | tee /etc/apt/sources.list.d/renci-irods.list

RUN apt-get update && \
    apt-get install -y \
        libcurl4-gnutls-dev \
        python3 \
        python3-distro \
        python3-jsonschema \
        python3-pip \
        python3-psutil \
        python3-requests \
        rsyslog \
        unixodbc \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/*

ARG irods_version=5.0.1
ARG irods_package_version_suffix=-0~noble
ARG irods_package_version=${irods_version}${irods_package_version_suffix}
ARG irods_package_plugin_version_suffix=-0+${irods_version}~noble
ARG irods_resource_plugin_version=5.0.0.0${irods_package_plugin_version_suffix}

RUN apt-get update && \
    apt-get install -y \
        irods-database-plugin-postgres=${irods_package_version} \
        irods-runtime=${irods_package_version} \
        irods-server=${irods_package_version} \
        irods-icommands=${irods_package_version} \
        irods-resource-plugin-s3=${irods_resource_plugin_version} \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/*

COPY unattended_install.json /
COPY s3.keypair /var/lib/irods/

WORKDIR /
COPY entrypoint.sh .
RUN chmod u+x ./entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]
