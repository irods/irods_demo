from irods.configuration import IrodsConfig
from irods import lib

config = IrodsConfig()

config.server_config['plugin_configuration']['rule_engines'].insert(1, {
    "instance_name": "irods_rule_engine_plugin-audit_amqp-instance",
    "plugin_name": "irods_rule_engine_plugin-audit_amqp",
    "plugin_specific_configuration" : {
         "amqp_location" : "ANONYMOUS@irods-audit-elastic-stack.example.org:5672",
         "amqp_options" : "",
         "amqp_topic" : "audit_messages",
         "pep_regex_to_match" : "audit_.*"
     }
})

config.server_config['rule_engine_namespaces'].insert(1, "audit_")
lib.update_json_file_from_dict(config.server_config_path, config.server_config)

