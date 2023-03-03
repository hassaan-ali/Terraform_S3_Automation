# 1. Create a Terraform block to mention the cloudprovider and it's version
# 2. Create a Provide Block to mention the aws region to use
# 3. Create a S3 Bucket
# 4. Create a lambda function to upload a file to the S3 bucket obtained from the environment variable
# 5. Create a role in IAM to allow lambda function to execute
# 6. Assign S3 bucket permissions to the lambda function role.
# 7. Delete all files if it is Sunday using delete_function
# 8. Check if there are any lingering file(s) using check_function

# Terraform Block
terraform {
  required_version = ">= 1.3.9"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  } 
}  
# Provider Block
provider "aws" {
  region = "us-east-2"
}

/*
Note-1:  AWS Credentials Profile (profile = "default") configured on your local desktop terminal  
$HOME/.aws/credentials
*/

resource "aws_s3_bucket" "S3_bucket_us-east-2" {
  bucket = "tf-bucket"
}

resource "aws_lambda_function" "upload_function" {
  #Add whichever file you want to upload to the bundle.zip
  filename = "bundle.zip"
  function_name = "upload_function"
  role = aws_iam_role.lambda_role.arn
  handler = "lambda_function.lambda_handler"
  runtime = "python3.9"
  source_code_hash = "${filebase64sha256("bundle.zip")}"

#The BUCKET_NAME environment variable is set to the name of the S3 bucket.
  environment {
    variables = { 
      BUCKET_NAME = "${aws_s3_bucket.S3_bucket_us-east-2.id}"
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role = aws_iam_role.lambda_role.name
}


resource "aws_lambda_function" "delete_function" {
  #Lamba funtion to delete all files in S3 bucket
  filename = "delete_S3_objects.zip"
  function_name = "delete_function"
  role = aws_iam_role.lambda_role.arn
  handler = "lambda_delete_function.lambda_handler"
  runtime = "python3.9"

#The BUCKET_NAME environment variable is set to the name of the S3 bucket.
  environment {
    variables = { 
      BUCKET_NAME = "${aws_s3_bucket.S3_bucket_us-east-2.id}"
    }
  }
}


resource "aws_lambda_function" "check_function" {
  #Lamba funtion to delete all files in S3 bucket
  filename = "check_lingering_files.zip"
  function_name = "check_function"
  role = aws_iam_role.lambda_role.arn
  handler = "check_lingering_files.lambda_handler"
  runtime = "python3.9"

#The BUCKET_NAME environment variable is set to the name of the S3 bucket.
  environment {
    variables = { 
      BUCKET_NAME = "${aws_s3_bucket.S3_bucket_us-east-2.id}"
    }
  }
}
