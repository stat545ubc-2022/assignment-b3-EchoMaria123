# STAT 545B Assignment b3 & b4

## Introduction

This is the repo for assignment-b3 and assignment-b4, STAT545B, in which two Shiny apps were deployed.\

## Description

**Choice of assignment b-3: Option A - BC Liquor app.**\
Added new features:
* Feature 1: add a logo image - this will make the user interface look more appealing.
* Feature 2: add color parameter to the plot - this could enable the user to decide on the colour of the bars in the plot, which is more flexible and could be used to differentiate different plots (Deleted in assignment b4 so since multiple choices were enabled, and the plot was generated using *fill = Type*).
* Feature 3: place plot and table in separate tabs - this way the user can switch between different figures, also the layout of the webpage will be more organized and concise. 
* Feature 4: show the number of results found whenever the filters change - this will give the user a direct numeric reflection of the number of results returned based on the filters chosen.

**Choice of assignment b-4: Option C - Shiny app.**\
For this option, I implemented some additional features and app design to my shiny app that I worked on in Assignment 3b.

* Add a description in the ui to guide the user to interact with the app
* Add a theme using the *shinythemes* package so the user interface looks more prettier
* Use the DT package to turn a static table into an interactive table so user now can choose the number of entries, sort the table and search for specific key word.
* Allow the user to download the result table as a .csv file.
* Allow the user to search for multiple countries and types of drink simultaneously, the plot now is generated using *fill = Type, facet_wrap(~Country)* so that it's more visually pleasant and easy to follow for the user
* Allow user to customize the *bins* paramater in histogram

## Link to Shiny app

The instance of the deployed Shiny app from assignment b-3 can be accessed through this *[Link-3b](https://echo123.shinyapps.io/BCLiquor_revised/)*.


The instance of the deployed Shiny app from assignment b-4 can be accessed through this *[Link-4b](https://echo123.shinyapps.io/BCLiquor_v2/)*.

## Acknowledgement

The basic version of this Shinny app is from *[Dean Attali's app](https://deanattali.com/blog/building-shiny-apps-tutorial/)*. The dataset used which provides us with information about products sold by BC Liquor Store is from *[OpenDataBC](https://catalogue.data.gov.bc.ca/dataset/bc-liquor-store-product-price-list-historical-prices)*. Source of logo image is from *[Wikipedia](https://en.wikipedia.org/wiki/File:BC_Liquor_Store_logo.svg)*.



