# coarse_grained_dynamics_with_maxent_data

Scripts to generate the data used in our paper:  
**_Coarse-grained dynamics in quantum many-body systems using the maximum entropy principle_**

[![DOI](https://zenodo.org/badge/1028082909.svg)](https://doi.org/10.5281/zenodo.16618926)

## Requirements

- `make`
- Wolfram Mathematica 14 (tested on version 14.2)

## Our Custom Toolbox

This repository contains `Quantum.m` and `Carlos.m` to guarantee easy and standalone functionality. These libraries were taken from our custom toolbox [`LIBS`](https://github.com/carlospgmat03/libs) (only tested on version [v3.1.0](https://github.com/carlospgmat03/libs/releases/tag/v3.1.0)).

## Generating Data Files

This repository uses a `makefile` to automate the generation of `.csv` data files from their corresponding Wolfram scripts (`.wls`).

### How to Use

To generate the data for a specific figure, run the `make` command followed by the name of the `.csv` file you want to create.

For example, to generate the data for Figure 1, run the following command in your terminal:

```bash
make fig_1_decay_data.csv
```
This will execute the necessary script (`swap_decay_rate.wls`) to produce the `fig_1_decay_data.csv` file.

### Generating Other Files
The process works in an analogous manner for all other data files (check makefile). Simply replace the target with the filename you need. For example:

- `make fig_1_inset.csv`

- `make fig_2_and_3_evol_data.csv`

- `make fig_4_ising_data.csv`

__Note:__ `make fig_5_convergence.csv` also produces `fig_5_inset_convergence.csv`.
