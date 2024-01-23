#!/usr/bin/env python
# coding: utf-8

import os
import sys

import psycopg2

from dotenv import load_dotenv
load_dotenv()

from digilab import create_client
from digilab import get_api
from digilab import get_property_ids
from digilab import get_property
from digilab import upload_property

# Command line variables
SENSOR_VARIABLE_NAME = sys.argv[1]
SENSOR_VARIABLE_TABLE = sys.argv[2]

# Arduinio Cloud
CLIENT_ID = os.getenv('CLIENT_ID')
CLIENT_SECRET = os.getenv('CLIENT_SECRET')
client = create_client(CLIENT_ID, CLIENT_SECRET)
api = get_api(client)

# PostgreSQL
connection = psycopg2.connect(user=os.getenv('LTS_USER'),
                                password=os.getenv('LTS_PASSWORD'),
                                host=os.getenv('LTS_HOST'),
                                port=os.getenv('LTS_PORT'),
                                database=os.getenv('LTS_DATABASE'))

id_list = get_property_ids(connection, SENSOR_VARIABLE_NAME)

# Query the Arduinio Cloud and upload to PostgreSQL
for property_ids in id_list:
    thing_id = property_ids[0]
    property_id = property_ids[1]
    property = get_property(api, thing_id, property_id)
    upload_property(connection, property, SENSOR_VARIABLE_TABLE)

connection.close()

