#!/bin/bash

# This script is a modified version of the run_fuzzer.sh script from benchmarks/script/multi-benches/Pillow/drivers/image_open/run-fuzzer.sh.

export AFL_SKIP_BIN_CHECK=1

if [ ! -d "fuzz" ]; then
   mkdir -p fuzz/in
   cp -rf tests/* fuzz/in/
fi

cd fuzz
#afl-system-config

#enable debug for child process
#export AFL_DEBUG_CHILD=1

#enable crash exit code
export AFL_CRASH_EXITCODE=100

cp ../../py_summary.xml ./
if [ "$?" != "0" ]; then
	echo "copy py_summary.xml fail, please check the configuration!!!!"
	exit 0
fi

export AFL_PL_HAVOC_NUM=128
#afl-fuzz $1 $2 -i in/ -o out -m none -d -- python ../image_load.py  @@

SEED_SET_DIR="/root/PolyFuzz/benchmarks/script/baselines/atheris/Pillow/drivers/image_load/tests"
rm -f atheris_seed_coverage_trace
afl-showmap -i $SEED_SET_DIR -o atheris_seed_coverage_trace -m none -C -- python ../image_load.py  @@

SEED_SET_DIR="/root/PolyFuzz/benchmarks/script/multi-benches/Pillow/drivers/image_load/tests"
rm -f polyfuzz_seed_coverage_trace
afl-showmap -i $SEED_SET_DIR -o polyfuzz_seed_coverage_trace -m none -C -- python ../image_load.py  @@