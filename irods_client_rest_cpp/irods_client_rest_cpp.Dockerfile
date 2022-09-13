FROM ubuntu:20.04

SHELL [ "/bin/bash", "-c" ]

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
        apt-transport-https \
        gnupg \
        lsb-release \
        rsyslog \
        sudo \
        wget \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/*

RUN wget -qO - https://packages.irods.org/irods-signing-key.asc | apt-key add - && \
    echo "deb [arch=amd64] https://packages.irods.org/apt/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/renci-irods.list

ARG version=0.9.2
ARG package_version_suffix=-0~focal
ARG package_version=${version}${package_version_suffix}

RUN apt-get update && \
    apt-get install -y irods-client-rest-cpp=${package_version} && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/*

# Use the default rsyslog configuration for this image
RUN cp /etc/irods_client_rest_cpp/irods_client_rest_cpp.conf.rsyslog /etc/rsyslog.d/00-irods_client_rest_cpp.conf && \
    cp /etc/irods_client_rest_cpp/irods_client_rest_cpp.logrotate /etc/logrotate.d/irods_client_rest_cpp

WORKDIR /
COPY entrypoint.sh .
RUN chmod u+x ./entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]
