#!/bin/bash

set -e

die() {
  echo >&2 "$@"
  exit 1
}

[ -z $APP_NAME ] || die "APP_NAME parameter required"
[ -z $CF_API_ENDPOINT ] || die "CF_API_ENDPOINT parameter required"
[ -z $ORG ] || die "ORG parameter required"
[ -z $SPACE ] || die "SPACE parameter required"
[ -z $USERNAME ] || die "USERNAME parameter required"
[ -z $PASSWORD ] || die "PASSWORD parameter required"
[ -z $CF_DOCKER_USERNAME ] || die "CF_DOCKER_USERNAME parameter required"
[ -z $CF_DOCKER_PASSWORD ] || die "CF_DOCKER_PASSWORD parameter required"

# TODO: for debugging purpose only, will be removed shortly
find .

echo "Login to \"$CF_API_ENDPOINT\" using organization \"$ORG\" and space \"$SPACE\""
cf login -a $CF_API_ENDPOINT -o $ORG -s $SPACE -u $USERNAME -p $PASSWORD

if [[ ${CF_MANIFEST_FILE} ]]; then
  echo "Deploy \"$APP_NAME\" using manifest file \"$CF_MANIFEST_FILE\""
  cf push $APP_NAME -f $CF_MANIFEST_FILE
else
  export NUM_INSTANCES=${NUM_INSTANCES:-"1"}
  export DISK=${DISK:-"1G"}
  export MEMORY=${MEMORY:-"1G"}
  export HEALTH_CHECK_TYPE=${HEALTH_CHECK_TYPE:-"port"}

  export ARGS="-i $NUM_INSTANCES -k $DISK -m $MEMORY --health-check-type $HEALTH_CHECK_TYPE"

  if [[ ${CF_DOCKER_IMAGE} ]]; then
    echo "Deploy \"$APP_NAME\" using docker image \"$CF_DOCKER_IMAGE\""
    cf push $APP_NAME --docker-image $CF_DOCKER_IMAGE --docker-username $CF_DOCKER_USERNAME $ARGS
  else
    echo "Deploy \"$APP_NAME\" using app directory \"$GITHUB_WORKSPACE/$ARTIFACT_PATH\""
    cf push $APP_NAME -p $GITHUB_WORKSPACE/$ARTIFACT_PATH $ARGS
  fi
fi
