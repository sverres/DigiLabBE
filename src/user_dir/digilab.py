#!/usr/bin/env python
# coding: utf-8

from oauthlib.oauth2 import BackendApplicationClient
from requests_oauthlib import OAuth2Session

import iot_api_client as iot
from iot_api_client.rest import ApiException
from iot_api_client.configuration import Configuration

import sys


def create_client(CLIENT_ID, CLIENT_SECRET):
    oauth_client = BackendApplicationClient(client_id=CLIENT_ID)
    token_url = "https://api2.arduino.cc/iot/v1/clients/token"

    oauth = OAuth2Session(client=oauth_client)
    token = oauth.fetch_token(
        token_url=token_url,
        client_id=CLIENT_ID,
        client_secret=CLIENT_SECRET,
        include_client_id=True,
        audience="https://api2.arduino.cc/iot",
    )

    access_token = token.get("access_token")

    client_config = Configuration(host="https://api2.arduino.cc/iot")
    client_config.access_token = access_token
    client = iot.ApiClient(client_config)

    return client


def get_property_ids(connection, SENSOR_VARIABLE_NAME):
    cursor = connection.cursor()
    postgres_query = f"select thing_id, property_id, variable_name from lts.current_config_view where variable_name='{SENSOR_VARIABLE_NAME}'"

    cursor.execute(postgres_query)
    id_list = []
    for record in cursor:
        id_list.append(record)
    cursor.close()

    return id_list


def get_api(client):
    api = iot.PropertiesV2Api(client)

    return api


def get_property(api, thing_id, property_id):
    try:
        resp = api.properties_v2_show(thing_id, property_id)
        property = (resp.id, resp.value_updated_at, resp.last_value)
        return property

    except ApiException as e:
        print("Got an exception: {}".format(e))


# define a function that handles and parses psycopg2 exceptions
def print_psycopg2_exception(err):
    # get details about the exception
    err_type, err_obj, traceback = sys.exc_info()

    # get the line number when exception occured
    line_num = traceback.tb_lineno

    # print the connect() error
    print ("\npsycopg2 ERROR:", err, "on line number:", line_num)
    print ("psycopg2 traceback:", traceback, "-- type:", err_type)

    # psycopg2 extensions.Diagnostics object attribute
    print ("\nextensions.Diagnostics:", err.diag)

    # print the pgcode and pgerror exceptions
    print ("pgerror:", err.pgerror)
    print ("pgcode:", err.pgcode, "\n")


def upload_property(connection, property, SENSOR_VARIABLE_TABLE):
    cursor = connection.cursor()

    property_id, measurement_time, value = property
    postgres_insert_query = f'INSERT INTO lts.{SENSOR_VARIABLE_TABLE}("property_id", "measurement_time", "value", "create_time") VALUES (%s,%s,%s,%s)'
    record_to_insert = (property_id, measurement_time, value, "now()")

    print(postgres_insert_query)
    print(property_id, measurement_time, value, "now()")

    try:
        cursor.execute(postgres_insert_query, record_to_insert)

    except Exception as err:
        # pass exception to function
        print_psycopg2_exception(err)

        # rollback the previous transaction before starting another
        connection.rollback()

    cursor.close()
    connection.commit()

