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


File to be uploaded should be part of bundle.zip and test event should be created in AWS Lambda with key "file_name" and value equal to the FILENAME.ext should be given. Test event needs to be created if testing from within aws console.

To Test the code, first appy the terraform script using "terraform apply --auto-approve" and then run the following commands to upload, delete and check lingering files respectively: (Prerequisite AWS CLI should be installed and configured):

#To Check if file upload is working
aws lambda invoke --function-name upload_function --cli-binary-format raw-in-base64-out --payload file://payload.json output.json
#To check if file(s) delete is working
aws lambda invoke --function-name delete_function --payload '{}' output.json
#To check if any lingering files exist
aws lambda invoke --function-name check_function --payload '{}' output.json