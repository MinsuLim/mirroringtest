#!/bin/bash -eu

set -e

# Build and push a docker image to ECR with Kaniko
#
# Script parameters:
# 1. ECR Repo
# Example usage:
# sh ./build-and-push-with-kaniko.sh 889051633962.dkr.ecr.ap-northeast-2.amazonaws.com/MYREPONAME

# Set env vars 
ECR_REPO=$1

# Set Kaniko build context location
DOCKERFILE_LOC=${CATEGORY}/${IMAGE_ENV}
# DOCKERFILE_LOC=executor/appimg
RUNNER_NAME=$(echo "$ECR_REPO" | awk -F '/' '{print $2}')
# ECR_REPO=056231226580.dkr.ecr.ap-northeast-2.amazonaws.com/jenkins-kaniko
# RUNNER_NAME=jenkins-kaniko
CONTEXT_FILE=context.tar.gz
CONTEXT_URI=s3://$CONTEXT_S3/$DOCKERFILE_LOC/$CONTEXT_FILE
# CONTEXT_URI=s3://jenkins-kaniko-ap-northeast-2/executor/appimg/context.tar.gz

# Make ECS CLI input file
sed -i -e "s|_SUBNET_|${KANIKO_SBN}|g" ./build-scripts/kaniko-run-task.json
sed -i -e "s|_SG_|${KANIKO_SG}|g" ./build-scripts/kaniko-run-task.json
sed -i -e "s|_CLUSTER_|${KANIKO_CLS}|g" ./build-scripts/kaniko-run-task.json
sed -i -e "s|_ECR_REPO_|${ECR_REPO}|g" ./build-scripts/kaniko-run-task.json
sed -i -e "s|_CONTEXT_URI_|${CONTEXT_URI}|g" ./build-scripts/kaniko-run-task.json

cat ./build-scripts/kaniko-run-task.json

# Upload context file
tar --exclude="./build-scripts" -zcvf ./build-scripts/$CONTEXT_FILE -C $DOCKERFILE_LOC . 
aws s3 cp ./build-scripts/$CONTEXT_FILE $CONTEXT_URI

# Run Kaniko task
echo "Starting Kaniko"
TASK_ARN=$(aws ecs run-task --task-definition ${KANIKO_TD} --cli-input-json file://build-scripts/kaniko-run-task.json | jq -j '.tasks[0].taskArn')

# Wait for build job to be completes
aws ecs wait tasks-running --cluster $KANIKO_CLS --task $TASK_ARN
echo "Building Docker image of ${RUNNER_NAME}"
aws ecs wait tasks-stopped --cluster $KANIKO_CLS --task $TASK_ARN

# Return build result
EXIT_CODE=$(aws ecs describe-tasks --cluster $KANIKO_CLS --tasks $TASK_ARN --query 'tasks[0].containers[0].exitCode' --output text)
if [ "$EXIT_CODE" = "0" ]
then
    echo "Successfully built and published Docker image of ${DOCKERFILE_LOC}"
else 
    echo "Container exited with unexpected exit code $EXIT_CODE. Check Cloudwatch logs for details."
    exit 1
fi