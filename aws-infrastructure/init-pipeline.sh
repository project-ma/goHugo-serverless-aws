#!/bin/bash
set -e
reset

# Update to use a different AWS profile
PROFILE=
STACK_NAME=
REGION=ap-southeast-2

echo "Create the initial CloudFormation Stack"
aws --profile ${PROFILE} --region ${REGION} cloudformation create-stack --stack-name ${STACK_NAME} --template-body file://pipeline.yml --parameters file://init-pipeline.json --capabilities "CAPABILITY_NAMED_IAM"
echo "Waiting for the CloudFormation stack to finish being created."
aws --profile ${PROFILE} --region ${REGION} cloudformation wait stack-create-complete --stack-name ${STACK_NAME}
# Print out all the CloudFormation outputs.
aws --profile ${PROFILE} --region ${REGION} cloudformation describe-stacks --stack-name ${STACK_NAME} --output table --query "Stacks[0].Outputs"
