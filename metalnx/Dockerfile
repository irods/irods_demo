FROM irods/metalnx:3.1.0

RUN apt-get update && \
    apt-get install -y \
        netcat-traditional \
    && \
    apt-get clean

WORKDIR /
COPY metalnx_entrypoint.sh .
RUN chmod u+x ./metalnx_entrypoint.sh
# CMD is overriding base image CMD. No ENTRYPOINT is specified in base image, which may be intentional.
CMD ["./metalnx_entrypoint.sh"]
