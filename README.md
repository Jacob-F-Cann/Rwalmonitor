# Rwalmonitor

### Project Description

DSCI 532 Individual Assignment - Group 2 Walmonitor in `R`

This R shiny dashboard application has been adpated from the python shiny dashboard application [here](https://yhouyang02-walmonitor.share.connect.posit.cloud/), created from this [repo](https://github.com/UBC-MDS/DSCI-532_2026_2_walmonitor).

The purpose of the dashboard is to provide meaningful sales metrics insight over time, to a Walmart Branch Manager overseeing sales performance for three walmart locations.

### Contributors
[Jacob Cann](https://github.com/Jacob-F-Cann)

### Usage Tutorial

#### Remote Viewing
1. View the app [here](https://jacob-f-cann-rwalmonitor.share.connect.posit.cloud/) on Posit Connect Cloud.

#### Locally Viewing/Editing/Publishing
1. Clone the repo:
   ```bash
   git clone https://github.com/Jacob-F-Cann/Rwalmonitor.git
   ```
   or:
   ```bash
   git clone git@github.com:Jacob-F-Cann/Rwalmonitor.git
   ```
2. Ensure that shiny is installed:
   ```r
   install.packages("shiny")
   ```
3. Ensure that the following dependencies are installed:
   ```r
   install.packages("bslib")
   install.packages("dplyr")
   install.packages("tidyverse")
   install.packages("ggplot2")
   install.packages("rsconnect")
   ```
4. Ensure that you create a `manifest.json` from the repo root if publishing to Posit Connect Cloud is desired:
   ```r
   rsconnect::writeManifest('my_app')
   ```
5. Test the deployment locally
   ```r
   options(shiny.autoreload = TRUE) # if you want real-time updates while editing app.R
   shiny::runApp("my_app")
   ```
6. Publish to Posit Connect Cloud:
   [Follow These Step-by-Step Instructions](https://docs.posit.co/connect-cloud/user/content/shiny.html)
