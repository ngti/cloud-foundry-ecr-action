#!/bin/bash

set -e

die() {
  echo >&2 "$@"
  exit 1
}

if [[ -z "$APP_NAME" ]]; then
  die "APP_NAME parameter required"
fi
if [[ -z "$CF_API_ENDPOINT" ]]; then
  die "CF_API_ENDPOINT parameter required"
fi
if [[ -z "$ORG" ]]; then
  die "ORG parameter required"
fi
if [[ -z "$SPACE" ]]; then
  die "SPACE parameter required"
fi
if [[ -z "$USERNAME" ]]; then
  die "USERNAME parameter required"
fi
if [[ -z "$PASSWORD" ]]; then
  die "PASSWORD parameter required"
fi
if [[ -z "$CF_DOCKER_USERNAME" ]]; then
  die "CF_DOCKER_USERNAME parameter required"
fi
if [[ -z "$CF_DOCKER_PASSWORD" ]]; then
  die "CF_DOCKER_PASSWORD parameter required"
fi

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
  export STACK=${STACK:-"cflinuxfs3"}

  export ARGS="-i $NUM_INSTANCES -k $DISK -m $MEMORY -s $STACK --health-check-type $HEALTH_CHECK_TYPE"

  if [[ ! -z "$CF_ROUTE_PATH" ]]; then
    export ARGS="$ARGS --route-path $CF_ROUTE_PATH"
  fi

  if [[ ${CF_DOCKER_IMAGE} ]]; then
    echo "Deploy \"$APP_NAME\" using docker image \"$CF_DOCKER_IMAGE\""
    cf push $APP_NAME --docker-image $CF_DOCKER_IMAGE --docker-username $CF_DOCKER_USERNAME $ARGS
  else
    echo "Deploy \"$APP_NAME\" using app directory \"$GITHUB_WORKSPACE/$ARTIFACT_PATH\""
    cf push $APP_NAME -p $GITHUB_WORKSPACE/$ARTIFACT_PATH $ARGS
  fi
fi
