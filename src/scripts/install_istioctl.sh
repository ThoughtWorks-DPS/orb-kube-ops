#!/bin/bash

function install() {
  echo "installing istioctl ${1}"
  curl -L https://istio.io/downloadIstio  | ISTIO_VERSION="${1}" sh -
  mv -f "istio-${1}/bin/istioctl" /usr/local/bin/istioctl
}

echo "requested istioctl ${INSTALL_ISTIOCTL_VERSION}"
echo "USE_SUDO = ${USE_SUDO}"

if [[ $INSTALL_ISTIOCTL_VERSION == "latest" ]]; then
  echo "install of 'latest' not supported"
  exit 1
else
  if [ "$USE_SUDO" == 1 ]; then
    sudo bash -c "$(declare -f install); install ${INSTALL_ISTIOCTL_VERSION};"
  else
    install ${INSTALL_ISTIOCTL_VERSION}
  fi
fi

istioctl version --short --remote=false || { echo "error: invalid istioctl version"; exit 2; }
