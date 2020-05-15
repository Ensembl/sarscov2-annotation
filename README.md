![Build Community Annotation](https://github.com/andrewyatz/sarscov2-community-import/workflows/Build%20Community%20Annotation/badge.svg)

# Loading the track hub

The public hub is held in /trackhub/hub.txt. This is compatible with the [Ensembl SARS-CoV-2 browser](https://covid-19.ensembl.org/Sars_cov_2). This hub is already attached to the browser.

To use the hub please link to https://raw.githubusercontent.com/ensembl/sarscov2-annotation/master/trackhub/hub.txt

# Data location

All data is held in the annotations directory.

- `bb` all BigBed files
- `vcf` VCF bgzip'd indexed files
- `as` AutoSQL definitions for the various files

# Community annotation

This repository will rebuild community annotation as it is specified in the /ucsc_annotations.csv file. The resulting BigBed is available for download from the community annotation build and in /annotations/bb/ucsc_annotations.bb.