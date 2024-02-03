#!/bin/bash

# Function to display a help message
usage() {
  cat << EOF
Usage: $0 [OPTIONS]

This script initializes a Terraform working directory and sets up the backend.

Options:
  -b AWS bucket name            Name of the S3 bucket to use for Terraform state.
  -d AWS DynamoDb table name    Name of the DynamoDB table to use for state locking.
  -r AWS region                 AWS region where the resources are located.

Environment variables:
  AWS_ACCESS_KEY_ID       AWS access key ID.
  AWS_SECRET_ACCESS_KEY   AWS secret access key.

Example:
  $0 -b my-bucket -d my-table -r us-west-2
EOF
}

# Parse command-line options
while getopts ":b:d:r:" opt; do
  case ${opt} in
    b) bucketName=${OPTARG};;
    d) dynamoDbTableName=${OPTARG};;
    r) awsRegion=${OPTARG};;
    \?)
      echo "Invalid option: -${OPTARG}" >&2
      usage
      ;;
    :)
      echo "Option -$OPTARG requires an argument." 1>&2
      usage
      ;;
  esac
done
shift $((OPTIND -1))

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null
then
    echo "AWS CLI could not be found, install it first."
fi

# Check if Terraform is installed
if ! command -v terraform &> /dev/null
then
    echo "Terraform could not be found, please install it and run this script again."
    exit 1
fi

# Check if AWS credentials are set
if [[ -z ${bucketName} ]] || [[ -z ${dynamoDbTableName} ]] || [[ -z ${awsRegion} ]]; then
    echo "One or more arguments are missing a value."
    exit 1
fi

if [[ -z "${AWS_ACCESS_KEY_ID}" ]] || [[ -z "${AWS_SECRET_ACCESS_KEY}" ]]; then
    echo "AWS credentials are not set, please set them and run this script again."
    exit 1
fi

export TF_VAR_BACKEND_BUCKET_NAME="${bucketName}"
export TF_VAR_BACKEND_TABLE_NAME="${dynamoDbTableName}"
export TF_VAR_AWS_REGION="${awsRegion}"
export AWS_REGION="${awsRegion}"

if [[ -e "terraform.tfstate" ]]; then
    rm terraform.tfstate
fi

# Initialize Terraform
terraform init

# Check if the S3 bucket exists in AWS
echo "Checking if the S3 bucket exists in AWS..."
if aws s3api head-bucket --bucket "${bucketName}" >/dev/null 2>&1; then
    echo "S3 bucket exists in AWS, importing it..."
    terraform import aws_s3_bucket.terraformState "${bucketName}"
else
    echo "S3 bucket does not exist in AWS, letting Terraform handle it..."
fi

# Check if the DynamoDB table exists in AWS
echo "Checking if the DynamoDB table exists in AWS..."
if aws dynamodb describe-table --table-name "${dynamoDbTableName}" --region "${awsRegion}" >/dev/null 2>&1; then
    echo "DynamoDB table exists in AWS, importing it..."
    terraform import aws_dynamodb_table.terraformLocks "${dynamoDbTableName}"
else
    echo "DynamoDB table does not exist in AWS, letting Terraform handle it..."
fi

terraform apply -auto-approve
