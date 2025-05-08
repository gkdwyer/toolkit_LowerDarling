# Toolkit template

This repo provides a template to get set up and use the toolkit. It is set up as an R project. It provides some environment setup help and a template Quarto notebook that uses the toolkit. Quarto comes with Rstudio or you can use quarto from the command line or VScode; to use it with VScode more easily, install the Quarto extension.

The recommended way to use the toolkit is to manage your own python environments. This is particularly the case if using on Azure. However, it is possible to just use R and it will auto-manage the python, but with less control for the user.

Either way, once you're set up, run the Quarto notebook `full_toolkit.qmd`, and if it renders, everything's working.

*See bottom of this doc for updating.*

## Setup

The Simplest section just installs HydroBOT. If you want more complexity, keep reading.

These steps are scripted in `project_setup.sh` (or `project_setup.bat`), which just runs the `poetry install` followed by `renv::restore()` described below, along with some extra helpers that try to catch python versions and C dependencies.

### Simplest

If you have R and python already and don't have issues with C libraries all you need to do is install HydroBOT.

```
# install.packages('renv')
renv::install('git@github.com:MDBAuth/HydroBOT.git',
              dependencies = 'all',
              rebuild = TRUE,
              upgrade = 'always',
              git = 'external',
              prompt = FALSE)

```

If you prefer {devtools}

```
# install.packages('devtools')
devtools::install_git('git@github.com:MDBAuth/HydroBOT.git',
              dependencies = 'all',
              rebuild = TRUE,
              git = 'external')
```

If you want to manage your own python libraries, run

```
poetry install
```

If you want to let R manage them through miniconda, skip that.

### Using the renv environments

If you want to use the renv environments as defined in the lockfile of this repo, instead of installing HydroBOT as above, run 

```
renv::restore()
```

To restore the R packages from the lockfile. 

If you want updates,

```
renv::update()
```

### git notes

The package and this repo are currently private to the MDBA github. You'll need to ensure [git and github are set up](set_up_git.md) to access them. Many of the steps here will be easier once it's public.

### Complexity- python, Linux, Azure

If you need to set up python environments or run on Azure or similar, use the setup files.

1.  Set up your system and ensure you have all dependencies for managing your python environment (and on Linux, the C libraries for R packages). The series of steps to follow for Linux and Windows are here:

    -   LINUX: [initial_azure_setup](initial_azure_setup.md)

    -   WINDOWS: [initial_windows_setup](initial_windows_setup.md)

2.  Set up the project environments. This can be done with scripts:

    -   LINUX: Running `./project_setup.sh` at a bash terminal should then set up the project itself on Linux.

    -   WINDOWS: Running `project_setup.bat` by double clicking it or at the command prompt will do the same on Windows.


------------------------------------------------------------------------

> ::: {#Azure-linux-note style="color: gray"}
>
> If you're on Linux, you'll want to run `Rscript 'R_setup.R'` in a terminal first to deal with C libraries, and to use notebooks install [quarto](https://quarto.org/) - instructions in [initial_azure_setup](initial_azure_setup.md).
>
> Ubuntu \>= 20.0 *highly* recommended, older versions have outdated geoprocessing libraries. To update your OS,
>
> ```         
> sudo apt-get update sudo apt-get upgrade
> ```
>
> :::

------------------------------------------------------------------------


## Run examples

We provide a couple examples of use

-   Run Quarto notebook `full_toolkit.qmd` that runs a simple set of analyses through the toolkit.
    -   Run this by opening it in VScode (install the Quarto extension first). You can run chunks or push the 'Preview' button to render. Otherwise, at the terminal `quarto render full_toolkit.qmd`.
    -   This (or parts of it) can be modified for your use.
-   The Quarto notebook `toolkit_params.qmd` is an example of a run with parameter files, using both external `yml` files and Quarto headers. Run it as before to test, and then modify as desired.

## Updating

If you've set your environment up, whether using this template or not, you may want to update the EWR tool or the toolkit at some point to take advantage of new functionality.

### Toolkit
If you want to install the toolkit or update it, use

```         
renv::install('git@github.com:MDBAuth/HydroBOT.git', rebuild = TRUE, upgrade = 'always', git = 'external', prompt = FALSE)
```

If you want a particular branch, use 

```
renv::install('git@github.com:MDBAuth/HydroBOT.git@branch_name', rebuild = TRUE, upgrade = 'always', git = 'external', prompt = FALSE)
```

### EWR tool
To update the EWR tool, use 

```
poetry add git+https://github.com/MDBAuth/EWR_tool.git#GalenH
```

The `#GalenH` gives the branch with netcdf capabilities.

If you want the release, all you need is 

```
poetry add py-ewr
```

### Template notebooks

New toolkit functionality may alter the template notebooks, or we may update the notebooks themselves as standard practice develops. To get new ones, pull from github.

## HPC

To run on an HPC, we need to 

```
module load R/4.3
module load python/3.9
```

and in any particular script, we need to set paths to libs

```
renvpaths <- .libPaths()
.libPaths(new = c(renvpaths,'/ceph-g/opt/R/4.3/lib/R/library' ))
Sys.setenv('R_LIBS' = '/ceph-g/opt/R/4.3/lib/R/library')
```
