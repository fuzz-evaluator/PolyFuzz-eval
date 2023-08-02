#!/bin/bash

set -e
set -o pipefail

DIR="$(dirname $(readlink -f $0))"
source $DIR/config.sh

docker pull fuzzevaluator/polyfuzz:v1.1
docker tag fuzzevaluator/polyfuzz:v1.1 "$DOCKER_IMAGE_NAME"
