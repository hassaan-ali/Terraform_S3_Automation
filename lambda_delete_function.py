import boto3
from datetime import datetime
import os
import json

s3 = boto3.resource('s3')

def lambda_handler(event, context):
    #Get the current date and time
    now = datetime.now()

    #Check if the day is Sunday
    if now.strftime('%A') == 'Sunday':
        bucket_name = os.environ['BUCKET_NAME']

        #Get a list of objects
        bucket = s3.Bucket(bucket_name)
        objects = bucket.objects.all()

        #Delete all objects:
        for obj in objects:
            obj.delete()

        return{
            'statusCode': 200,
            'body': 'All current files have been sucessfully deleted'
        }
    else:
        return {
            'statusCode': 200,
            'body': 'No files deleted'
        }
