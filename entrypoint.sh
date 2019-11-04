#!/bin/sh

set -e

cf login -a $CF_API_ENDPOINT -o $ORG -s $SPACE -u $USERNAME -p $PASSWORD

if [ -z "$DOCKER_IMAGE" ]
then
  CF_DOCKER_PASSWORD=$DOCKER_HUB_PASSWORD cf push $APP_NAME --docker-image $DOCKER_IMAGE --docker-username $DOCKER_HUB_USERNAME
else
  cf push $APP_NAME -p $GITHUB_WORKSPACE/$ARTIFACT_PATH
fi