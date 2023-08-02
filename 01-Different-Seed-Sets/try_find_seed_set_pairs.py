import  subprocess
from collections import defaultdict
from pathlib import Path
import json
from typing import Dict
import hashlib

# Requires seeds to be extract via:
# find -name "seeds_corpus.tar.gz" -execdir mkdir tests \;  -execdir tar -xzf {} -C tests \;

# Returns mapping of hash to file path
def hash_dir(path: str) -> Dict[str, str]:
    ret = dict()
    for p in Path(path).glob('*'):
        if not p.is_file():
            continue
        digest = hashlib.md5(p.read_bytes()).hexdigest()
        ret[digest] = p
    return ret

drivers_to_seed_folders = defaultdict(list)
drivers = list(Path('../PolyFuzz-upstream').rglob('**/drivers')) + [Path('./baseline/benchmark/AtherisBenchmark')]
for driver in drivers:
    subfolders = [f for f in driver.glob('*') if f.is_dir()]
    for folder in subfolders:
        seed_folder: Path = (folder / 'tests')
        if seed_folder.exists():
            drivers_to_seed_folders[folder.name].append(seed_folder.as_posix())

print(json.dumps(drivers_to_seed_folders, indent=4))

for driver, seed_folder in drivers_to_seed_folders.items():
    if len(seed_folder) > 1:
        if 'baseline' in seed_folder[0]:
            seed_folder_a = seed_folder[0]
            seed_folder_b = seed_folder[1]
        else:
            seed_folder_a = seed_folder[1]
            seed_folder_b = seed_folder[0]

        cmd = f'diff -q {seed_folder_a} {seed_folder_b}'

        ret = subprocess.run(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, check=False, encoding='utf8')

        if not ret.stdout:
            continue
        print('------------------------------------')
        print(f'driver={driver}')
        print(f'=> {cmd}')
        #print(ret.stdout, flush=True)

        seed_hash_mapping_a = hash_dir(seed_folder_a)
        seed_hashes_a = set(seed_hash_mapping_a.keys())

        seed_hash_mapping_b = hash_dir(seed_folder_b)
        seed_hashes_b = set(seed_hash_mapping_b.keys())

        only_a_hashes = seed_hashes_a - seed_hashes_b
        only_b_hashes = seed_hashes_b - seed_hashes_a
        print(f'#files only availabel to A: {len(only_a_hashes)}')
        print(f'#files only availabel to B: {len(only_b_hashes)}')
