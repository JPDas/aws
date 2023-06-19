import json
import logging
import boto3

from datetime import datetime
from snowflake.snowpark import Session


logger = logging.getLogger()
logger.setLevel(logging.INFO)

S3_BUCKET_NAME = "metrics-learning-bucket"

s3_client = boto3.client('s3', 
                              aws_access_key_id = 'AKIATNHOIVSE7VFZL6PI',
                              aws_secret_access_key = '1srRrmM0bz9yYwhy7ilmsV2D7FMI1Ve1A0D86die',
                              region_name = 'us-east-1'
)

connection_parameters = {
    "account": "<your snowflake account>",
    "user": "<your snowflake user>",
    "password": "<your snowflake password>",
    "role": "<your snowflake role>",  # optional
    "warehouse": "<your snowflake warehouse>",  # optional
    "database": "<your snowflake database>",  # optional
    "schema": "<your snowflake schema>",  # optional
}
def handler(event, context):

    cur_time = datetime.now()
    logger.info(f"Invoked the lambda function at time ::{cur_time}")
    snow_session = Session.builder.configs(connection_parameters).create()
    response = s3_client.list_objects_v2(Bucket=S3_BUCKET_NAME)
    files = response.get("Contents")
    for file in files:
        logger.info(f"file_name: {file['Key']}, size: {file['Size']}")

        res = s3_client.get_object(Bucket=S3_BUCKET_NAME, Key=file['Key'])
        bytes = res['Body'].read()

        logger.info(f"Read file::{bytes}")


    snow_session.close()






    