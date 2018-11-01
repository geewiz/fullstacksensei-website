#!/usr/bin/env bash
#
# Deploy from Travis CI to Kubernetes
#
# # Required information in env variables
#
# ## Docker registry
#
# * `DOCKER_REGISTRY`: Domain name of the Docker image registry
# * `DOCKER_USERNAME`: Login name for the image registry
# * `DOCKER_PASSWORD`: Login name for the image registry
#
# ## Kubernetes deployment
#
# * `K8S_ENDPOINT`: The cluster's API URL
# * `K8S_CA`: The cluster's CA certificate
# * `K8S_TOKEN`: The service account's access token
# * `K8S_NAMESPACE`: The namespace to deploy to
#

set -o pipefail
set -o errexit

CA_CERT_PATH=$(mktemp)

if [ -n "$TRAVIS_REPO_SLUG" ]; then
  echo "Running CI deployment."
  PROJECT_NAME=${TRAVIS_REPO_SLUG#*/}

  echo "Logging into Docker registry..."
  echo "${DOCKER_PASSWORD}" | docker login -u="${DOCKER_USERNAME}" --password-stdin ${DOCKER_REGISTRY}

  echo "Installing k8s CLI..."
  curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
  chmod +x ./kubectl
  sudo mv ./kubectl /usr/local/bin/kubectl

  echo "Setting up k8s context..."
  echo $K8S_CA | base64 --decode -i - > $CA_CERT_PATH
  kubectl config set-cluster mykube --embed-certs=true --server=${K8S_ENDPOINT} --certificate-authority=$CA_CERT_PATH
  kubectl config set-credentials deploy_user --token=$K8S_TOKEN
  kubectl config set-context cideploy --cluster=mykube --user=deploy_user --namespace=$K8S_NAMESPACE
  kubectl config use-context cideploy
  kubectl config current-context
else
  echo "Running development deployment."
  source .deploy_env
fi

set -o nounset

echo "Building Docker image..."
DOCKER_IMAGE="${DOCKER_REGISTRY}/${DOCKER_ORGANISATION}/${PROJECT_NAME}"
docker build -t ${DOCKER_IMAGE}:latest .
docker push ${DOCKER_IMAGE}:latest

echo "Deploying to Kubernetes..."
kubectl apply -n ${K8S_NAMESPACE} -f k8s
kubectl set image -n ${K8S_NAMESPACE} deployment/${PROJECT_NAME} middleman=$(docker inspect --format='{{index .RepoDigests 0}}' ${DOCKER_IMAGE}:latest)

function cleanup {
  echo "Cleaning up..."
  rm "${CA_CERT_PATH}"
  echo "Done."
}

trap cleanup EXIT
