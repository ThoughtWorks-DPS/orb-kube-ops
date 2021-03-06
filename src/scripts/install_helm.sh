#!/bin/bash

function install() {
  echo "installing helm ${1}"
  curl -SLO "https://get.helm.sh/helm-v${1}-linux-amd64.tar.gz"
  sudo tar -xf "helm-v${1}-linux-amd64.tar.gz"
  sudo mv -f linux-amd64/helm /usr/local/bin
}

function install_latest() {
  echo "installing helm latest"
  curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
  VERIFY_CHECKSUM=false bash ./get_helm.sh
}

echo "requested helm ${INSTALL_HELM_VERSION}"

if [[ $INSTALL_HELM_VERSION == "latest" ]]; then
  if [ "$(id -u)" = 0 ]; then
    install_latest
  else
    sudo bash -c "$(declare -f install_latest); install_latest;"
  fi
else
  if [ "$(id -u)" = 0 ]; then
    install ${INSTALL_HELM_VERSION}
  else
    sudo bash -c "$(declare -f install); install ${INSTALL_HELM_VERSION};"
  fi
fi

helm version --short || { echo "error: invalid helm version"; exit 2; }
