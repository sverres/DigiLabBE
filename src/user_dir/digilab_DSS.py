#!/usr/bin/env python
# coding: utf-8

import sys
import requests


def get_property_ids(connection, SENSOR_VARIABLE_NAME):
    cursor = connection.cursor()
    postgres_query = f"select thing_id, property_id, variable_name from lts.current_config_view where variable_name='{SENSOR_VARIABLE_NAME}' and site_id = 'DSS'"

    cursor.execute(postgres_query)
    id_list = []
    for record in cursor:
        id_list.append(record)
    cursor.close()

    return id_list


def get_property(api, thing_id, property_id, SENSOR_VARIABLE_NAME):
    api_response = requests.get(api)
    if api_response.status_code == 200:
        
        api_data = api_response.json()
        
        field_list = {}
        
        fields = ('field1','field2','field3','field4','field5', 'field6')
        for field in fields:
            if api_data['channel'].get(field):
                sensor_type = api_data['channel'].get(field)
                field_list[sensor_type] = field

        noise = api_data['feeds'][0].get(field_list.get('noise'))
        illuminance = api_data['feeds'][0].get(field_list.get('illuminance'))
        humidity = api_data['feeds'][0].get(field_list.get('humidity'))
        temperature = api_data['feeds'][0].get(field_list.get('temperature'))
        pirmotion_reading = api_data['feeds'][0].get(field_list.get('pirmotion'))
        measurement_time = api_data['feeds'][0].get('created_at')
        
        if pirmotion_reading == '0.00000':
            pirmotion = False
        else:
            pirmotion = True
        
        api_data_dict = {
            'noise': noise,
            'illuminance': illuminance,
            'humidity': humidity,
            'temperature': temperature,
            'pirmotion': pirmotion,
        }
        
        property = (property_id, measurement_time, api_data_dict[SENSOR_VARIABLE_NAME])
        
        print(pirmotion_reading, pirmotion, api_data_dict['pirmotion'])
        print(property)
        
        return property
    
    else:
        api_data = None


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

