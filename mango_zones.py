import os
import ssl
import requests

API_URL = os.environ.get(
    "API_URL", "https://icts-p-coz-data-platform-api.cloud.icts.kuleuven.be"
)
API_TOKEN = os.environ.get("API_TOKEN", "")

DEFAULT_IRODS_PARAMETERS = {"port": 1247, "irods_authentication_scheme": "native"}
# {   "port": 1247,
#     "irods_authentication_scheme": "PAM",
#     "irods_ssl_ca_certificate_file": "",
#     "irods_ssl_verify_server": "cert",
#     "irods_default_resource": "default",
# }

ssl_context = ssl.create_default_context(
    purpose=ssl.Purpose.SERVER_AUTH, cafile=None, capath=None, cadata=None
)

DEFAULT_SSL_PARAMETERS = {}
# {
#     "client_server_negotiation": "request_server_negotiation",
#     "client_server_policy": "CS_NEG_REQUIRE",
#     "encryption_algorithm": "AES-256-CBC",
#     "encryption_key_size": 32,
#     "encryption_num_hash_rounds": 16,
#     "encryption_salt_size": 8,
#     "ssl_context": ssl_context,
# }

# Dict of irods zones
irods_zones = {
    "tempZone": {
        "parameters": {
            "host": "irods-catalog-provider",
            "zone": "tempZone",
        },
        "ssl_settings": {},
        "admin_users": [],
        "logo": "mango-logo.png",  # path in static folder
        "splash_image": "inca_quipu.jpg",
    },
}
