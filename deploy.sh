#!/bin/bash

read -rp "What aws cli profile are you using" Profile
read -rp "What is the domain you are deploying to" HostedZoneDomain

sam deploy \
  --no-fail-on-empty-changeset \
  --stack-name "SRE-Challenge" \
  --template cfn-codepipeline.yml \
  --capabilities 'CAPABILITY_NAMED_IAM' \
  --region "us-east-1" \
  --parameter-overrides \
    ParameterKey=HostedZoneDomain,ParameterValue="${HostedZoneDomain}" \
  --Profile "${Profile}"
