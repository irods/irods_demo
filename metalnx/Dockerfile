FROM irods/metalnx:2.6.1

RUN apt-get update && \
    apt-get install -y \
        netcat \
        postgresql-client \
    && \
    apt-get clean

WORKDIR /
COPY metalnx_entrypoint.sh .
RUN chmod u+x ./metalnx_entrypoint.sh
# CMD is overriding base image CMD. No ENTRYPOINT is specified in base image, which may be intentional.
CMD ["./metalnx_entrypoint.sh"]
