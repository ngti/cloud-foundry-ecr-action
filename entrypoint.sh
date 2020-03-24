#!/bin/bash

set -e

export NUM_INSTANCES=${NUM_INSTANCES:-"1"}
export DISK=${DISK:-"1G"}
export MEMORY=${MEMORY:-"1G"}
export HEALTH_CHECK_TYPE=${HEALTH_CHECK_TYPE:-"port"}

export ARGS="-i $NUM_INSTANCES -k $DISK -m $MEMORY --health-check-type $HEALTH_CHECK_TYPE"

cf login -a $CF_API_ENDPOINT -o $ORG -s $SPACE -u $USERNAME -p $PASSWORD

if [[ ${CF_DOCKER_IMAGE} ]]; then
  cf push $APP_NAME --docker-image $CF_DOCKER_IMAGE --docker-username $CF_DOCKER_USERNAME $ARGS
else
  cf push $APP_NAME -p $GITHUB_WORKSPACE/$ARTIFACT_PATH $ARGS
fi
