import json
import os
import boto3

s3 = boto3.resource('s3')

def lambda_handler(event, context):
    #Get the name of the S3 bucket from the eviornment variable
    bucket_name = os.environ['BUCKET_NAME']

    #Get the name of the file to be uploaded from the event object
    file_name = event['file_name']

    #upload the file to the S3 bucket
    s3.Bucket(bucket_name).upload_file(file_name, file_name)

    return{
        'statusCode' : 200,
        'body' : 'File uploaded successfully'
    }