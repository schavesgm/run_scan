# Automatic fitting of correlation functions on SLURM based servers.
---

These set of scripts automatise the production of fitted parameters on the
server SuperComputing Wales. 

## Production of data

* __run_fits.sh__. Main script to run, it iterates over all possible time directions
inside `../data` Note that the data has to be included inside a folder with the 
following structure `*x32`. The script calls the files inside `/utils` to generate
the needed files. In order to run an array of jobs that will fit all the possible
temperatures and flavors for a given channel, the following command shall be used,

```bash
    bash run_fits.sh channel type ansatz
```

### Channels
    1. Pseudoscalar ``g5`` -- 0-+
    2. Vector ``vec`` -- 1--
    3. Axial plus ``ax_plus`` -- 1++
    4. Axial minus ``ax_minus`` -- 1+-
    5. Scalar ``g0`` -- 0++

### Types
    1. ``ll`` -- local-local
    2. ``ss`` -- smeared-smeared

### Ansatz
    1. ``cosh`` -- Cosh ansatz
    2. ``exp`` -- Exponential ansatz
    3. ``cosh-void`` -- Cosh + Constant term ansatz

## Organisation of data 

* __fetch_data.sh__. Script to retrieve the data fitted and organise it inside the folder
`../outputs`. The data is then fetched for each temperature and meson and cleaned to make
it easier to analyse afterwards. It uses scripts from `/utils`. In order to run the
script, the following command shall be used,

```bash
    bash fetch_data.sh channel type ansatz
```
