# coarse_grained_dynamics_with_maxent_data

Scripts to generate the data used in our paper:  
**_Coarse-grained dynamics in quantum many-body systems using the maximum entropy principle_**

## Requirements

- `make`
- Wolfram Mathematica version 14 or later
- Our custom toolbox [`LIBS`](https://github.com/carlospgmat03/libs)

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

## Creating the Data

To be completed...
