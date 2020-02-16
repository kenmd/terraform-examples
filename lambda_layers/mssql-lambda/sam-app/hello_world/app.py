import os
import pyodbc
import json

# import requests


def lambda_handler(event, context):
    """Sample pure Lambda function

    Parameters
    ----------
    event: dict, required
        API Gateway Lambda Proxy Input Format

        Event doc: https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-proxy-integrations.html#api-gateway-simple-proxy-for-lambda-input-format

    context: object, required
        Lambda Context runtime methods and attributes

        Context doc: https://docs.aws.amazon.com/lambda/latest/dg/python-context-object.html

    Returns
    ------
    API Gateway Lambda Proxy Output Format: dict

        Return doc: https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-proxy-integrations.html
    """

    # try:
    #     ip = requests.get("http://checkip.amazonaws.com/")
    # except requests.RequestException as e:
    #     # Send some context about this error to Lambda Logs
    #     print(e)

    #     raise e

    # Note: PORT seems not working
    driver = os.getenv("DB_DRIVER", '{ODBC Driver 17 for SQL Server}')
    server = os.getenv("DB_SERVER", '127.0.0.1,1433')
    port = os.getenv("DB_PORT", "buggy")
    database = os.getenv("DB_DATABASE", 'master')
    uid = os.getenv("DB_UID", 'sa')
    pwd = os.getenv("DB_PWD", 'Password1')

    connection = (f"DRIVER={driver};SERVER={server};PORT={port};" +
                f"DATABASE={database};UID={uid};PWD={pwd}")

    cnxn = pyodbc.connect(connection)
    cursor = cnxn.cursor()

    with cursor.execute("SELECT @@version;"):
        row = cursor.fetchone()
        print(row[0])

    return {
        "statusCode": 200,
        "body": json.dumps({
            "message": "hello world",
            # "location": ip.text.replace("\n", "")
        }),
    }
