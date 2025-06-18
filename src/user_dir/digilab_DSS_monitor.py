#!/usr/bin/env python
# coding: utf-8

import os
import sys

import requests
import psycopg2

from dotenv import load_dotenv
load_dotenv()

from digilab_DSS import get_property_ids
from digilab_DSS import get_property
from digilab_DSS import upload_property

# Command line variables
SENSOR_VARIABLE_NAME = sys.argv[1]
SENSOR_VARIABLE_TABLE = sys.argv[2]


# PostgreSQL
connection = psycopg2.connect(user=os.getenv('LTS_USER'),
                                password=os.getenv('LTS_PASSWORD'),
                                host=os.getenv('LTS_HOST'),
                                port=os.getenv('LTS_PORT'),
                                database=os.getenv('LTS_DATABASE'))

id_list = get_property_ids(connection, SENSOR_VARIABLE_NAME)

# Query Thingspeak and upload to PostgreSQL
for property_id in id_list:
    thing_id = property_id[0]
    property_id = property_id[1]
    api = f"https://api.thingspeak.com/channels/{thing_id}/feeds.json?results=1"
    property = get_property(api, thing_id, property_id, SENSOR_VARIABLE_NAME)
    print(property)
    #upload_property(connection, property, SENSOR_VARIABLE_TABLE)

connection.close()
