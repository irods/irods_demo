from irods.configuration import IrodsConfig
from irods import lib

config = IrodsConfig()

config.server_config['plugin_configuration']['rule_engines'].insert(0, {
    "instance_name": "irods_rule_engine_plugin-update_collection_mtime-instance",
    "plugin_name": "irods_rule_engine_plugin-update_collection_mtime",
    "plugin_specific_configuration": {}
})

lib.update_json_file_from_dict(config.server_config_path, config.server_config)
