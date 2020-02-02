import os
import logging
import json

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def lambda_handler(event, context):
    logger.info(event)

    if "queryStringParameters" in event:
        name = event["queryStringParameters"].get("name", "bar")
    else:
        name = "foo"
   
    return {
        "statusCode": 200,
        "body": "Hello " + name
    }
