# Using the web to predict regional trade flows: data extraction, modelling, and validation.

[Emmanouil Tranos](https://etranos.info/)<sup>1</sup>\*, [Andre Carrascal Incera](https://sites.google.com/view/andrecarrascalincera/home)<sup>2</sup>
and George Willis<sup>3</sup>.

<sup>1</sup>University of Bristol and The Alan Turing Institute, [e.tranos@bristol.ac.uk](mailto:e.tranos@bristol.ac.uk), [@EmmanouilTranos](https://twitter.com/emmanouiltranos)

<sup>2</sup>University of Oviedo, [carrascalandre@uniovi.es](mailto:carrascalandre@uniovi.es), [@Andre_Carrascal](https://twitter.com/Andre_Carrascal)

<sup>3</sup>University of Birmingham, [gcw519@student.bham.ac.uk](mailto:gcw519@student.bham.ac.uk), [@GeorgeWGeog](https://twitter.com/GeorgeWGeog)

\* corresponding author

This is the depository for the 'Using the web to predict regional trade flows: data extraction, modelling, and validation.' paper.

To cite this article:

Tranos, E., A. Carrascal Incera and G. Willis (2022) Using the web to predict regional trade flows: data extraction, modelling, and validation, *Annals of the American Association of Geographers*, [DOI: 10.1080/24694452.2022.2109577](https://www.tandfonline.com/doi/full/10.1080/24694452.2022.2109577)

```
@article{regional_trade_hyperlinks,
author = {Emmanouil Tranos and Andre Carrascal Incera and George Willis},
title = {Working from Home and Digital Divides: Resilience during the Pandemic},
journal = {Annals of the American Association of Geographers},
volume = {0},
number = {0},
pages = {1-21},
year  = {2022},
publisher = {Taylor & Francis},
doi = {10.1080/24694452.2022.2109577},
}
```
The online appendix can be found [here](https://etranos.info/regional_trade_hyperlinks/).

## Abstract

Despite the importance of interregional trade for building effective regional economic policies, there is very little hard data to illustrate such interdependencies. We propose here a novel research framework to predict interregional trade flows by utilising freely available web data and machine learning algorithms. Specifically, we extract hyperlinks between archived websites in the UK and we aggregate these data to create an interregional network of hyperlinks between geolocated and commercial webpages over time. We also use some existing interregional trade data to train our models using random forests and then make out-of-sample predictions of interregional trade flows using a rolling-forecasting framework. Our models illustrative great predictive capability with $R^2$ greater than 0.9. We are also able to disaggregate our predictions in terms of industrial sectors, but also at a sub-regional level, for which trade data are not available. In total, our models provide a proof of concept that the digital traces left behind by physical trade can help us capture such economic activities at a more granular level and, consequently, inform regional policies.


## Reproduce the analysis

- `/scrips/io_data.Rmd`, `/scrips/io_data_sectors.Rmd` and
`/scrips/io_data_multi_pc.Rmd` prepare the data that is used for the
modelling. They prepare the data for the base models, the sectoral models 
and the models based on the websites with multiple postcodes. 
The appendix of the paper includes a detailed description of the web data creation
process.

- The data can be found under the `/scripts/data/` folder. The two main data sets 
used for the analysis are the following:

    - the [JISC UK Web Domain Dataset (1996-2013)](https://data.webarchive.org.uk/opendata/ukwa.ds.2/), which can be found in the `/data/NUTS210_hyperlinks/weighted` folder, and 

    - the [PBL EUREGIO database (2000-2010)](https://data.europa.eu/data/datasets/pbl-euregio-database-2000-2010?locale=en), which can be found in the `/data/IO` folder.

- `/scrips/test_t2.Rmd` trains and tests the base model as well as some alternative
specifications using as input the websites with one unique postcode. 
It creates the `/data_inter/test_t2.RData`, which is then used by the 
document which produces the paper (`/paper/submission2/hl_v2.Rmd`).

- `/scrips/test_t2_sectors.Rmd` repeats the analysis for each sector
separately. It also creates the `/paper/submission2/figures/sector_rsquared.png` image.

- `/scripts/test_t2_multi_pc.Rmd` repeats the analysis for websites with
multiple postcodes. It creates the `/data_inter/test_t2_multi_pc.RData`, 
which is then used by the document which produces the paper 
(`/paper/submission2/hl_v2.Rmd`).

- `/scripts/test_t2_LADs.Rmd` makes the trade predictions for Local Authority Districts (LADs). It's outputs are used to make the LADs maps (Figure 7) using the `/scripts/Maps.Rmd` and the [online supplementary material](https://etranos.info/regional_trade_hyperlinks/).  

- `/scripts/index.Rmd` produces the [online supplementary material](https://etranos.info/regional_trade_hyperlinks/). 

- `/scripts/test_t2_lasso.Rmd` introduces the LASSO estimator, which is used in the appendix (`/paper/submission2/appendix.Rmd`).
