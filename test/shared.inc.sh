#!/usr/bin/env bash
# Copyright 2018 Mirantis
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

if [ $(uname) = Darwin ]; then
  readlinkf(){ perl -MCwd -e 'print Cwd::abs_path shift' "$1";}
else
  readlinkf(){ readlink -f "$1"; }
fi
DIND_ROOT="$(cd $(dirname "$(readlinkf "${BASH_SOURCE}")") && cd .. ; pwd)"

tempdir="$(mktemp -d)"
trap 'rm -rf -- "$tempdir"' EXIT
export KUBECTL_DIR="${tempdir}"
export KUBECONFIG="${KUBECTL_DIR}/kube.conf"

function fail() {
  local msg="$1"
  echo -e "\033[1;31m${msg}\033[0m" >&2
  return 1
}

function get-ip-for-pod() {
  local pod_name="$1"
  local mode="$2"

  kubectl="${kubectl:-kubectl}"

  local verision=""
  if [[ ${mode} = "ipv6" ]]; then
      version="6"
  fi

  ip="$( $kubectl exec $pod_name ip addr list eth0 | grep inet | awk '$1 == "inet${version}" {print $2}' )"
  if [[ -n "$ip" ]]; then
      echo "$ip"
  else
      echo "UNKNOWN"
  fi
}

function get-node-selector-override() {
  local node="${1}"
  echo '{ "apiVersion": "v1", "spec": { "nodeSelector": { "kubernetes.io/hostname": "'"$node"'" } } }'
}

function get-hostname-override() {
  local name="${1}"
  echo '{ "apiVersion": "v1", "spec": { "hostname": "'"$name"'" } }'
}

function starts-with() {
  local needle="$1"
  local haystack="$2"
  [[ "$haystack" = "$needle"* ]]
}
