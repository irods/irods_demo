FROM irods/nfsrods:2.1.0

# Install netcat in order to poke irods-catalog-provider
RUN apt-get update && \
    apt-get install -y \
        netcat \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/*

WORKDIR /
COPY start.sh .
RUN chmod u+x ./start.sh
ENTRYPOINT ["./start.sh"]
