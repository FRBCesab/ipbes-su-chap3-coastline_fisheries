# IPBES Sustainable Use Assessment - Figure Chap3 Global Fisheries by Coastline

[![License: CC BY 4.0](https://img.shields.io/badge/License-CC%20BY%204.0-lightgreen.svg)](https://choosealicense.com/licenses/cc-by-4.0/)

This repository contains the code to reproduce the Figure 'Global Fisheries by Coastline' of 
the chapter 3 of the **IPBES Sustainable Use Assessment**. This figure shows the 
the global relative abundance of fisheries by coastline.

![](figures/ipbes-su-chap3-coastline_fisheries.png)


## System Requirements

This project handles spatial objects with the R package
[`sf`](https://cran.r-project.org/web/packages/sf/index.html). This
package requires some system dependencies (GDAL, PROJ and GEOS). Please
visit [this page](https://github.com/r-spatial/sf/#installing) to
correctly install these tools.


## Missing data

Two spatial layers are required and must be added in the folder `data/`:
- World maritime boundaries EEZ v11 (available [here](https://marineregions.org/downloads.php))
- Natural Earth ocean boundaries (available [here](https://www.naturalearthdata.com/downloads/50m-physical-vectors/50m-ocean/))


## Usage

First clone this repository, then open the R script `make.R` and run it.
This script will read data stored in the folder `data/` and export the figure
in the folder `figures/`.


## License

This work is licensed under 
[Creative Commons Attribution 4.0 International](https://choosealicense.com/licenses/cc-by-4.0/).

Please cite this work as: [...]

