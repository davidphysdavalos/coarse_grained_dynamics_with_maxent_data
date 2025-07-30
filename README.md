# coarse_grained_dynamics_with_maxent_data

Scripts to generate the data used in our paper:  
**_Coarse-grained dynamics in quantum many-body systems using the maximum entropy principle_**

## Requirements

- `make`
- Wolfram Mathematica version 14 or later
- Our custom toolbox [`LIBS`](https://github.com/carlospgmat03/libs) (at least version [v3.1.0](https://github.com/carlospgmat03/libs/releases/tag/v3.1.0))

## Installation on Linux-based Systems

1. Clone or download the [`libs`](https://github.com/carlospgmat03/libs) repository into your home folder:

    ```bash
    git clone https://github.com/carlospgmat03/libs ~/libs
    ```

2. Add the following line to your `~/.Wolfram/Kernel/init.m` file:

    ```mathematica
    AppendTo[$Path, FileNameJoin[{"/home/" <> ToString[$Username], "libs"}]];
    ```

> **Note**: If `init.m` does not exist, create the file and the necessary directory path.

## Generating Data Files

This repository uses a `makefile` to automate the generation of the `.csv` data files from their corresponding Wolfram scripts (`.wls`).

### How to Use

To generate the data for a specific figure, run the `make` command followed by the name of the `.csv` file you want to create.

For example, to generate the data for Figure 1, run the following command in your terminal:

```bash
make fig_1_decay_data.csv
```
This will execute the necessary script (`swap_decay_rate.wls`) to produce the `fig_1_decay_data.csv` file.

The `make` command is efficient. It will only run the script if the data file doesn't exist.

### Generating Other Files
The process works in an analogous manner for all other data files. Simply replace the target with the filename you need. For example:

- `make fig_1_inset.csv`

- `make fig_2_and_3_evol_data.csv`

- `make fig_4_ising_data.csv`
