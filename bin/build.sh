#!/usr/bin/env bash
set -o pipefail
set -o errexit

if [ -n "$TRAVIS_REPO_SLUG" ]; then
  echo "Running CI build."
  PROJECT_NAME=${TRAVIS_REPO_SLUG#*/}
  docker login -u="${DOCKER_USERNAME}" -p="${DOCKER_PASSWORD}" ${DOCKER_REGISTRY}
else
  echo "Running development build."
  source .deploy_env
fi

set -o nounset

DOCKER_IMAGE="${DOCKER_REGISTRY}/${DOCKER_ORGANISATION}/${PROJECT_NAME}"

docker build -t ${DOCKER_IMAGE}:latest .
