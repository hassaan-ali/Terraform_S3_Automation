# Terraform_S3_Automation
Terraform will create a S3 bucket. Python script will raise an alert if files are found in that S3 bucket.

Steps in creation of terraform file:
# 1. Create a Terraform block to mention the cloudprovider and it's version
# 2. Create a Provide Block to mention the aws region to use
# 3. Create a S3 Bucket
# 4. Create a lambda function to upload a file to the S3 bucket obtained from the environment variable
# 5. Create a role in IAM to allow lambda function to execute
# 6. Assign S3 bucket permissions to the lambda function role.
# 7. Delete all files if it is Sunday using delete_function
# 8. Check if there are any lingering file(s) using check_function


File to be uploaded should be part of bundle.zip and test event should be created in AWS Lambda with key "file_name" and value equal to the FILENAME.ext should be given.