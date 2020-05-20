#FROM irods/nfsrods:latest 

FROM ubuntu:16.04

RUN apt-get update && \
    apt-get install -y apt-transport-https maven git openjdk-8-jdk \
                       ninja-build less vim wget lsb-release gcc g++ python curl

RUN wget -qO - https://packages.irods.org/irods-signing-key.asc | apt-key add -; \
    echo "deb [arch=amd64] https://packages.irods.org/apt/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/renci-irods.list; \
    apt-get update && \
    apt-get install -y irods-dev irods-externals-cmake3.11.4-0

ENV PATH=/opt/irods-externals/cmake3.11.4-0/bin:$PATH
ENV NFSRODS_CONFIG_HOME=/nfsrods_config

ARG _github_account="irods"
ARG _sha="0.9.4"

RUN git clone https://github.com/${_github_account}/irods_client_nfsrods

RUN cd irods_client_nfsrods && \
    git checkout ${_sha} && \
    mvn clean install -Dmaven.test.skip=true

RUN curl -fSL https://github.com/jwilder/dockerize/releases/download/v0.6.1/dockerize-linux-amd64-v0.6.1.tar.gz -o dockerize-linux-amd64-v0.6.1.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-v0.6.1.tar.gz
CMD dockerize -wait tcp://icat.example.org:1247 -timeout 250s echo "NFSRODS found iRODS!" && java -Dlog4j2.contextSelector=org.apache.logging.log4j.core.async.AsyncLoggerContextSelector -jar /irods_client_nfsrods/irods-vfs-impl/target/nfsrods-0.9.4-jar-with-dependencies.jar
