import os
import json
import logging
import mysql.connector as mysql

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def lambda_handler(event, context):
    logger.info("START: %s", event)

    if event["command"] == "run_query":
        people = run_query(event["args"])
        return {
            "status": "success",
            "result": json.dumps(people),
        }
    else:
        raise Exception("unknown command")


def run_query(args):
    query = args["query"]
    logger.info("run_query: %s", query)

    cnx = mysql.connect(
        host=os.getenv("DB_SERVER", "127.0.0.1"),
        user=os.getenv("DB_USERNAME", "docker"),
        passwd=os.getenv("DB_PASSWORD", "docker"),
        database=os.getenv("DB_DATABASE", "db_example"),
    )

    cursor = cnx.cursor()
    cursor.execute(query)

    people = cursor.fetchall()

    for person in people:
        logger.info(person)

    return people
