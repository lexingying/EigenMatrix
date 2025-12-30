# EigenMatrix
Eigenmatrix for unstructured sparse recovery

## Python versions of the MATLAB scripts

The original MATLAB scripts (`run*.m`, `cmpF.m`) have been translated to Python in `python/`.

### Setup

```bash
python3 -m pip install -r requirements.txt
```

### Run

From the repo root:

```bash
python3 python/cmpF.py
python3 python/runD.py
python3 python/runF.py
python3 python/runL.py
python3 python/runR.py
python3 python/runS.py
```

Each script runs headlessly and writes EPS figures into the current working directory (matching the MATLAB filenames like `exF_11.eps`, `cmp_1.eps`, etc.).
