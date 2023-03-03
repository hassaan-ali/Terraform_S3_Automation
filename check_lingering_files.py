import json
import boto3
import os

s3 = boto3.resource('s3')

def lambda_handler(event, context):
    bucket_name = os.environ['BUCKET_NAME']

     #Get a list of objects
    bucket = s3.Bucket(bucket_name)
    objects = bucket.objects.all()

    count_obj = 0

    for obj in objects:
        count_obj += 1


    if count_obj == 0:
        return {
            'statusCode': 200,
            'body': 'No lingering file(s) found'
        }
    else:
        return{
            'statusCode': 200,
            'body': str(count_obj) + ' lingering files found'
        }
    


