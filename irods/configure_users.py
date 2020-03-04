
import os
import sys
import json

from irods.configuration import IrodsConfig
from irods import lib
from irods.test import session

rods = session.make_session_for_existing_admin()

rods.assert_icommand('iadmin mkuser alice rodsuser')
rods.assert_icommand('iadmin moduser alice password apass')

