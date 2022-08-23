#!/bin/bash

function install() {
  echo "installing argocd ${1}"
  curl -sSL -o argocd https://github.com/argoproj/argo-cd/releases/download/v${1}/argocd-linux-amd64
  chmod +x argocd
  mv ./argocd /usr/local/bin/argocd
}

function install_latest() {
  echo "installing argocd latest"
  curl -sSL -o argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
  chmod +x argocd
  mv ./argocd /usr/local/bin/argocd
}

echo "requested argocd ${INSTALL_ARGOCD_VERSION}"

if [[ $INSTALL_ARGOCD_VERSION == "latest" ]]; then
  if [ "$USE_SUDO" == 1 ]; then
    install_latest
  else
    sudo bash -c "$(declare -f install_latest); install_latest;"
  fi
else
  if [ "$USE_SUDO" == 1 ]; then
    install ${INSTALL_ARGOCD_VERSION}
  else
    sudo bash -c "$(declare -f install); install ${INSTALL_ARGOCD_VERSION};"
  fi
fi

argocd version --client || { echo "error: invalid argocd version"; exit 2; }
