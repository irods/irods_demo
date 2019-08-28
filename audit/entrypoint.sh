#! /bin/bash
chown rabbitmq:rabbitmq /var/lib/rabbitmq/.erlang.cookie
service elasticsearch start
service logstash start
service rabbitmq-server start
service kibana start
curl http://localhost:9200
curl -XPUT "http://localhost:9200/irods_audit"
rabbitmqctl add_user test test
rabbitmqctl set_user_tags test administrator
rabbitmqctl set_permissions -p / test ".*" ".*" ".*"
curl -XPUT http://localhost:9200/irods_audit/_settings -H 'Content-Type: application/json' -d'{"index.mapping.total_fields.limit": 2000}'
tail -f /dev/null
#/bin/bash

