
import os
import sys
import json

from irods.configuration import IrodsConfig
from irods import lib
from irods.test import session

config = IrodsConfig()

config.server_config['plugin_configuration']['rule_engines'].insert(1, {
    "instance_name": "irods_rule_engine_plugin-unified_storage_tiering-instance",
    "plugin_name": "irods_rule_engine_plugin-unified_storage_tiering",
    "plugin_specific_configuration" : {
     }
})

lib.update_json_file_from_dict(config.server_config_path, config.server_config)

rods = session.make_session_for_existing_admin()

rods.assert_icommand('iadmin mkresc mid_tier unixfilesystem localhost:/tmp/irods/mid_tier', 'STDOUT_SINGLELINE', 'mid_tier')
rods.assert_icommand('iadmin mkresc arch_tier unixfilesystem localhost:/tmp/irods/arch_tier', 'STDOUT_SINGLELINE', 'arch_tier')

rods.assert_icommand('imeta set -R demoResc irods::storage_tiering::group example_group 0')
rods.assert_icommand('imeta set -R mid_tier irods::storage_tiering::group example_group 1')
rods.assert_icommand('imeta set -R arch_tier irods::storage_tiering::group example_group 2')

rods.assert_icommand('imeta set -R demoResc irods::storage_tiering::time 30')
rods.assert_icommand('imeta set -R mid_tier irods::storage_tiering::time 60')

rule = """
{
   "rule-engine-instance-name": "irods_rule_engine_plugin-unified_storage_tiering-instance",
   "rule-engine-operation": "irods_policy_schedule_storage_tiering",
   "delay-parameters": "<INST_NAME>irods_rule_engine_plugin-unified_storage_tiering-instance</INST_NAME><EF>REPEAT FOR EVER</EF>",
   "storage-tier-groups": [
"example_group"
   ]
}
INPUT null
OUTPUT ruleExecOut
"""

with open('/var/lib/irods/tiering_rule.r', 'w') as f:
   f.write(rule)

rods.assert_icommand('irule -r irods_rule_engine_plugin-unified_storage_tiering-instance -F /var/lib/irods/tiering_rule.r')

