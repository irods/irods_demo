FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
        apt-transport-https \
        gnupg \
        wget \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/*

RUN wget -qO - https://packages.irods.org/irods-signing-key.asc | apt-key add - && \
    echo "deb [arch=amd64] https://packages.irods.org/apt/ noble main" | tee /etc/apt/sources.list.d/renci-irods.list

ARG icommands_version=5.0.1
ARG icommands_package_version_suffix=-0~noble
ARG icommands_package_version=${icommands_version}${icommands_package_version_suffix}

RUN apt-get update && \
    apt-get install -y \
        irods-icommands=${icommands_package_version} \
        irods-runtime=${icommands_package_version} \
        netcat-traditional \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/*

RUN mkdir -p /root/.irods
COPY irods_environment.json /root/.irods

WORKDIR /
COPY entrypoint.sh .
RUN chmod u+x ./entrypoint.sh
ENTRYPOINT bash -c "./entrypoint.sh"
