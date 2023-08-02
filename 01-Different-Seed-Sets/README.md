# 01-Different-Seed-Sets

This experiment aims to study the impact of using different seed sets in fuzzing. Since we failed to build PolyFuzz using a Ubuntu 18.04 Docker container (which is supported as of the artifacts [README.md](https://github.com/fuzz-evaluator/PolyFuzz-upstream/blob/main/README.md), we need to rely on a prebuilt Docker image `daybreak2019/polyfuzz:v1.1` provided via Docker Hub. To ensure availability, we made a copy of the Docker image which can be found [here](https://hub.docker.com/r/fuzzevaluator/polyfuzz). For the following procedure, our copy of the PolyFuzz image is used to guarantee reliability.

For reproduction, it is sufficient to execute `run.sh`. This script will
  1. Pull the PolyFuzz Docker image (~100 GiB)
  2. Run the `./build.sh` script that is part of PolyFuzz (this takes around 10 minutes to finish)
  3. Execute `run_pillow_image_load_with_different_seeds_sets.sh` to compute the coverage for `image_load` harness of Pillow.
  4. Copy the coverage traces `polyfuzz_seed_coverage_trace`(coverage achieved by the seed used for PolyFuzz), and `atheris_seed_coverage_trace` (coverage of the atheris seed set) into this folder.


## Layout
We provide a number of convenience scripts:
- `try_find_seed_set_pairs.py`: A script that automatically finds pairs of seed directories and compares them. This is provided on best effort basis and likely only finds a subset of all available seed sets.
- `run_pillow_image_load_with_different_seeds_sets.sh`: Script copied by the `run.sh` script into the PolyFuzz container to compute coverage for the two seed sets.
- `polyfuzz_seed_coverage_trace` and `atheris_seed_coverage_trace`: The coverage traces produced by `run.sh`.
