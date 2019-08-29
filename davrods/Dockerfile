FROM ubuntu:16.04

RUN apt-get update && apt-get install -y wget curl apache2 sudo lsb-release apt-transport-https

RUN wget -qO - https://packages.irods.org/irods-signing-key.asc | sudo apt-key add - && \
    echo "deb [arch=amd64] https://packages.irods.org/apt/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/renci-irods.list && \
    sudo apt-get update

RUN wget -O /davrods.deb https://github.com/UtrechtUniversity/davrods/releases/download/4.2.6_1.4.2/davrods-4.2.6-1.4.2.deb && apt install -y /davrods.deb

RUN sed -i "s/^#//g" /etc/apache2/sites-available/davrods-vhost.conf
RUN sed -i "s/ServerName.*/ServerName irods-davrods.example.org/" /etc/apache2/sites-available/davrods-vhost.conf
RUN sed -i "s/#DavRodsServer.*/DavRodsServer icat.example.org 1247/" /etc/apache2/sites-available/davrods-vhost.conf

RUN a2enmod dav && a2enmod davrods && a2ensite davrods-vhost && a2dissite 000-default && service apache2 restart

RUN curl -fSL https://github.com/jwilder/dockerize/releases/download/v0.6.1/dockerize-linux-amd64-v0.6.1.tar.gz -o dockerize-linux-amd64-v0.6.1.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-v0.6.1.tar.gz
CMD dockerize -wait tcp://icat.example.org:1247 -timeout 250s tail -f /dev/null
