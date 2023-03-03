echo "Uploading a file README.md"
aws lambda invoke --function-name upload_function --cli-binary-format raw-in-base64-out --payload file://payload.json output.json; cat output.json
sleep 3
echo  "\n\nDeleting all files in S3 bucket. Files will only be delete if it is a Sunday"
aws lambda invoke --function-name delete_function --payload '{}' output.json ; cat output.json
sleep 3
echo  "\n\nChecking for lingering files"
aws lambda invoke --function-name check_function --payload '{}' output.json ; cat output.json
