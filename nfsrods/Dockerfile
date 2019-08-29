FROM irods/nfsrods:latest 

RUN apt-get update && \
    apt-get install -y curl tar

RUN curl -fSL https://github.com/jwilder/dockerize/releases/download/v0.6.1/dockerize-linux-amd64-v0.6.1.tar.gz -o dockerize-linux-amd64-v0.6.1.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-v0.6.1.tar.gz
CMD dockerize -wait tcp://icat.example.org:1247 -timeout 250s tail -f /dev/null
