#!/bin/bash

set -eu
set -o pipefail

DIR="$(dirname "$(readlink -f $0)")"
ROOT_DIR="$(readlink -f "$DIR/..")"
source "$ROOT_DIR/config.sh"

pushd .. > /dev/null
./prepare.sh
popd > /dev/null

container_id=$(docker run --rm  -td $DOCKER_IMAGE_NAME bash)

# Build PolyFuzz
docker exec -it $container_id bash -ic "cd /root/PolyFuzz/ && ./build.sh"

# Copy script that runs targets with both seed sets
docker cp run_pillow_image_load_with_different_seeds_sets.sh "$container_id:/root/PolyFuzz/benchmarks/script/multi-benches/Pillow/drivers/image_load/"

# Run the script copied above.
docker exec -i $container_id bash -ic "cd /root/PolyFuzz/benchmarks/script/multi-benches/Pillow/drivers/image_load/ && ./run_pillow_image_load_with_different_seeds_sets.sh"

# Get coverage reports
docker cp "$container_id:/root/PolyFuzz/benchmarks/script/multi-benches/Pillow/drivers/image_load/fuzz/atheris_seed_coverage_trace" .
docker cp "$container_id:/root/PolyFuzz/benchmarks/script/multi-benches/Pillow/drivers/image_load/fuzz/polyfuzz_seed_coverage_trace" .

docker rm -f $container_id
