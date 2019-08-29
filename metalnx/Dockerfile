FROM tomcat:jre8-alpine

LABEL organization="iRODS Consortium"
LABEL description="Metalnx iRODS Browser"

RUN apk add curl

RUN wget -qO- https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/5.2.4/flyway-commandline-5.2.4-linux-x64.tar.gz | tar xvz \
 && ln -s `pwd`/flyway-5.2.4/flyway /usr/local/bin

COPY migrations /migrations

COPY runit.sh /
RUN chmod +x /runit.sh
COPY metalnx.war /usr/local/tomcat/webapps/

RUN curl -fSL https://github.com/jwilder/dockerize/releases/download/v0.6.1/dockerize-linux-amd64-v0.6.1.tar.gz -o dockerize-linux-amd64-v0.6.1.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-v0.6.1.tar.gz
CMD dockerize -wait tcp://icat.example.org:1247 -wait tcp://irods-metalnx-db.example.org:5432 -timeout 250s /runit.sh
