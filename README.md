# Artifact Evaluation
This repository contains the experiments that we conducted to evaluate the [artifact](https://github.com/Daybreak2019/PolyFuzz) of [PolyFuzz (paper)](https://www.usenix.org/conference/usenixsecurity23/presentation/li-wen).

## Conducted Experiment(s)
As part of a larger effort to reproduce fuzzing research, we have selected PolyFuzz for reproduction. In the following, we outline our experiment(s) to evaluate PolyFuzz and the paper's claims.

### [01-Different-Seed-Sets](./01-Different-Seed-Sets)
After analyzing the artifact of PolyFuzz, we noticed that different sets of initial seeds have been used for the competitors for multiple targets. Giving one fuzzer seeds that another one has no access to risks and inherent unfairness, as seeds provide a crucial first step in accessing a target. Note that some seed sets are compressed and must be extracted first, which we have already done for the fork at [PolyFuzz-upstream](https://github.com/fuzz-evaluator/PolyFuzz-upstream). One example of a case with different initial seed sets is the `image_load` target of the Python image processing library `Pillow`, as shown by running `diff`. To make sure that the differences are not caused by file renaming, we hashed each file and compared the seed sets based on these hashes (see [01-Different-Seed-Sets](./01-Different-Seed-Sets) for details).
```
diff -q ./PolyFuzz-upstream/benchmarks/script/baselines/atheris/Pillow/drivers/image_load/tests ../PolyFuzz-upstream/benchmarks/script/multi-benches/Pillow/drivers/image_load/tests

# Files only available to atheris
Only in ./PolyFuzz-upstream/benchmarks/script/baselines/atheris/Pillow/drivers/image_load/tests: 05f13e0259336f8a4d9501fbf1bbeaac97b51d0a
Only in ./PolyFuzz-upstream/benchmarks/script/baselines/atheris/Pillow/drivers/image_load/tests: 1cfb33fe8e6ab55e3a9b03c2b978c1e70f9834b4
Only in ./PolyFuzz-upstream/benchmarks/script/baselines/atheris/Pillow/drivers/image_load/tests: 1d7a9de036548532610f7f236923d4f7af990685
Only in ./PolyFuzz-upstream/benchmarks/script/baselines/atheris/Pillow/drivers/image_load/tests: 5e5592307bbb551f50af6362360b01ccd3cb51b6

# Files only available to PolyFuzz
Only in ./PolyFuzz-upstream/benchmarks/script/multi-benches/Pillow/drivers/image_load/tests: crash-0c7e0e8e11ce787078f00b5b0ca409a167f070e0.tif
Only in ./PolyFuzz-upstream/benchmarks/script/multi-benches/Pillow/drivers/image_load/tests: crash-0da013a13571cc8eb457a39fee8db18f8a3c7127.tif
Only in ./PolyFuzz-upstream/benchmarks/script/multi-benches/Pillow/drivers/image_load/tests: crash-0e16d3bfb83be87356d026d66919deaefca44dac.tif
Only in ./PolyFuzz-upstream/benchmarks/script/multi-benches/Pillow/drivers/image_load/tests: crash-1152ec2d1a1a71395b6f2ce6721c38924d025bf3.tif
Only in ./PolyFuzz-upstream/benchmarks/script/multi-benches/Pillow/drivers/image_load/tests: crash-1185209cf7655b5aed8ae5e77784dfdd18ab59e9.tif
Only in ./PolyFuzz-upstream/benchmarks/script/multi-benches/Pillow/drivers/image_load/tests: crash-338516dbd2f0e83caddb8ce256c22db3bd6dc40f.tif
Only in ./PolyFuzz-upstream/benchmarks/script/multi-benches/Pillow/drivers/image_load/tests: crash-465703f71a0f0094873a3e0e82c9f798161171b8.sgi
Only in ./PolyFuzz-upstream/benchmarks/script/multi-benches/Pillow/drivers/image_load/tests: crash-4f085cc12ece8cde18758d42608bed6a2a2cfb1c.tif
Only in ./PolyFuzz-upstream/benchmarks/script/multi-benches/Pillow/drivers/image_load/tests: crash-4fb027452e6988530aa5dabee76eecacb3b79f8a.j2k
Only in ./PolyFuzz-upstream/benchmarks/script/multi-benches/Pillow/drivers/image_load/tests: crash-63b1dffefc8c075ddc606c0a2f5fdc15ece78863.tif
Only in ./PolyFuzz-upstream/benchmarks/script/multi-benches/Pillow/drivers/image_load/tests: crash-64834657ee604b8797bf99eac6a194c124a9a8ba.sgi
Only in ./PolyFuzz-upstream/benchmarks/script/multi-benches/Pillow/drivers/image_load/tests: crash-6b7f2244da6d0ae297ee0754a424213444e92778.sgi
Only in ./PolyFuzz-upstream/benchmarks/script/multi-benches/Pillow/drivers/image_load/tests: crash-74d2a78403a5a59db1fb0a2b8735ac068a75f6e3.tif
Only in ./PolyFuzz-upstream/benchmarks/script/multi-benches/Pillow/drivers/image_load/tests: crash-754d9c7ec485ffb76a90eeaab191ef69a2a3a3cd.sgi
Only in ./PolyFuzz-upstream/benchmarks/script/multi-benches/Pillow/drivers/image_load/tests: crash-7d4c83eb92150fb8f1653a697703ae06ae7c4998.j2k
Only in ./PolyFuzz-upstream/benchmarks/script/multi-benches/Pillow/drivers/image_load/tests: crash-86214e58da443d2b80820cff9677a38a33dcbbca.tif
Only in ./PolyFuzz-upstream/benchmarks/script/multi-benches/Pillow/drivers/image_load/tests: crash-abcf1c97b8fe42a6c68f1fb0b978530c98d57ced.sgi
Only in ./PolyFuzz-upstream/benchmarks/script/multi-benches/Pillow/drivers/image_load/tests: crash-b82e64d4f3f76d7465b6af535283029eda211259.sgi
Only in ./PolyFuzz-upstream/benchmarks/script/multi-benches/Pillow/drivers/image_load/tests: crash-c1b2595b8b0b92cc5f38b6635e98e3a119ade807.sgi
Only in ./PolyFuzz-upstream/benchmarks/script/multi-benches/Pillow/drivers/image_load/tests: crash-ccca68ff40171fdae983d924e127a721cab2bd50.j2k
Only in ./PolyFuzz-upstream/benchmarks/script/multi-benches/Pillow/drivers/image_load/tests: crash-d2c93af851d3ab9a19e34503626368b2ecde9c03.j2k
Only in ./PolyFuzz-upstream/benchmarks/script/multi-benches/Pillow/drivers/image_load/tests: crash-db8bfa78b19721225425530c5946217720d7df4e.sgi
Only in ./PolyFuzz-upstream/benchmarks/script/multi-benches/Pillow/drivers/image_load/tests: crash-f46f5b2f43c370fe65706c11449f567ecc345e74.tif
```

The first interesting thing is that some files contain the substring `crash`. These stem from the [unit tests](https://github.com/python-pillow/Pillow/blob/6d3630d4061b32ac2f1b34cd5c852da72e3e8655/Tests/images/crash-0c7e0e8e11ce787078f00b5b0ca409a167f070e0.tif) of `Pillow` and are used to test whether a previously found bug was fixed. Using such unit tests is not inherently a problem.

Nevertheless, using different seed sets is problematic. To show this, we design an experiment where we measure the initial coverage achieved by PolyFuzz if executed with the different seed sets. 

Our results show that using the seed set given to atheris, a competitor of Polyfuzz, the initial seed set covers 218 edges.
```
[*] Scanning '/root/PolyFuzz/benchmarks/script/baselines/atheris/Pillow/drivers/image_load/tests'...
[+] Captured 218 tuples (highest value 255, total values 63811) in 'atheris_seed_coverage_trace'.
[+] A coverage of 218 edges were achieved out of 4194304 existing (0.01%) with 39 input files.

```

However, when we use the seed set PolyFuzz uses, we achieve an initial coverage of 814 edges. This is more than three times more coverage, giving Polyfuzz a much better foundation for further fuzzing efforts.
```
[*] Scanning '/root/PolyFuzz/benchmarks/script/multi-benches/Pillow/drivers/image_load/tests'...
[+] Captured 814 tuples (highest value 255, total values 133883) in 'polyfuzz_seed_coverage_trace'.
[+] A coverage of 814 edges were achieved out of 4194304 existing (0.02%) with 58 input files
```

While it would be interesting to see the ramifications regarding both competitors, we could not perform such an experiment: The artifact does not provide any tooling to compute coverage for atheris, and we were also unable to execute atheris, since the artifact provides no information regarding its setup in the context of the Polyfuzz paper.
