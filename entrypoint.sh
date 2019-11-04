#!/bin/sh

set -e

echo $CF_API_ENDPOINT
echo $ORG
echo $USERNAME
echo $PASSWORD

cf login -a $CF_API_ENDPOINT -o $ORG -s $SPACE -u $USERNAME -p $PASSWORD

if [ -z "$DOCKER_IMAGE" ]
then
  CF_DOCKER_PASSWORD=$CF_DOCKER_PASSWORD cf push $APP_NAME --docker-image $CF_DOCKER_IMAGE --docker-username $CF_DOCKER_USERNAME
else
  cf push $APP_NAME -p $GITHUB_WORKSPACE/$ARTIFACT_PATH
fi