import json
import random
import string
import random
import string
import re

def lambda_handler(event, context):
    message = 'Hello {} !'.format(event['key1'])
    return {
       'message' : message
    }