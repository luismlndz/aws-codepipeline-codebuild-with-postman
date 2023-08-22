#!/usr/bin/env bash

#This shell script updates Postman environment file with the API Gateway URL created
# via the api gateway deployment

echo "Running update-postman-env-file.sh"

api_gateway_url=`aws cloudformation describe-stacks \
  --stack-name space-eyes-api-stack \
  --query "Stacks[0].Outputs[*].{OutputValueValue:OutputValue}" --output text`

echo "API Gateway URL:" ${api_gateway_url}

jq -e --arg apigwurl "$api_gateway_url" '(.values[] | select(.key=="apigw-root") | .value) = $apigwurl' \
  SpaceEyesAPIEnvironment.postman_environment.json > SpaceEyesAPIEnvironment.postman_environment.json.tmp \
  && cp SpaceEyesAPIEnvironment.postman_environment.json.tmp SpaceEyesAPIEnvironment.postman_environment.json \
  && rm SpaceEyesAPIEnvironment.postman_environment.json.tmp

echo "Updated SpaceEyesAPIEnvironment.postman_environment.json"

cat SpaceEyesAPIEnvironment.postman_environment.json