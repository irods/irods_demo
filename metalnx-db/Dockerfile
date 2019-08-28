FROM postgres:9.4

# Setup catalog database
ADD db_commands.txt /
RUN service postgresql start
RUN su - postgres -c 'psql -f /db_commands.txt'

ENTRYPOINT ["tail -f /dev/null"]
