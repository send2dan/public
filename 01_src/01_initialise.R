# here --------------------------------------------------------------------

if (!require("here")) {
  install.packages("here",
    repos = "https://packagemanager.posit.co/cran/latest", # "https://cran.r-project.org/"
    type = "win.binary"
  )
}

library(here)

# Package list ---------------------------------

# install {renv} if not already done so
if (!require("renv")) {
  install.packages("renv",
    repos = "https://packagemanager.posit.co/cran/latest", # "https://cran.r-project.org/"
    type = "win.binary"
  )
}

library(renv)

# set repos for {renv}
options(
  renv.config.repos.override = "https://packagemanager.posit.co/cran/latest",
  renv.config.install.verbose = TRUE, # This will give more information in the console while installing the R packages, which may give more error details
  renv.config.connect.timeout = 5, # default is 20 seconds
  renv.config.connect.retry = 1, # default is 3
  renv.download.override = utils::download.file
  # renv.download.trace = TRUE # useful for debugging
)

# https://rstudio.github.io/renv/reference/config.html#renv-config-cache-symlinks

# list packages to download -----------------------------------------------

packages_to_download <- c(
  "dotenv", # for reading ".env" file
  "formatR", #The formatR package is required by the chunk option tidy = TRUE (further down)
  "bookdown", # required to set knitr options
  "excel.link",
  "here", # for finding files
  "tidytext", # for text cleaning tools
  "shiny", # for viewing rendered quarto reports (?)
  "quarto", # for quarto report rendering scripts
  "DT", #for tables (interactive) 
  "flextable", # for creating pretty (non-interactive) tables
  "reactable", # for creating interactive tables in quarto reports
  "plotly", # for creating interactive charts in quarto reports
  "patchwork", #to create ggplot patchworks
  #"scales",
  "fontawesome",
  "ellmer", # for LLMs
  "gitcreds", # for GitHub copilot
  "gargle", # for Google authentication
  "curl", # required for ellmer
  "ragnar", # for RAG workflows
  "rvest", # for reading html file contents
  "scales",
  "fs", # to create directories and move files etc..
  # "dplyr",
  "lubridate", # for dates and times - also incl in tidyverse
  "igraph", #for network analysis of linked patients
  "ggraph",  #for network analysis of linked patients
  "visNetwork", #for network analysis of linked patients
  "zoo", #time related calcs e.g. zoo::rollmean
  "NHSRplotthedots", #tools for drawing statistical process control (SPC) charts. This package supports NHS England’s ‘Making Data Count’ programme, and allows users to draw XmR charts, use change points, and apply rules with summary indicators for when rules are breached.
  # "stringr",
  # "forcats",
  # "purrr",
  # "copypasta",
  "AMR", # for antimicrobial resistance analysis
  "gt",
  "gtExtras",
  "kableExtra",
  "broom", 
  "odbc", # for SQL connection to APEX
  "DBI", # for SQL connection to APEX
  "RSQLite", # to create database files
  "tidyverse",
  "RColorBrewer", # for colour palettes
  "readr", #to read csv files
  "readxl", #to read excel files
  "janitor", # clean_names function
  "bench", # for timing SQL queries
  "Microsoft365R", # for connecting R to Outlook for email sending
  "blastula", # for composing HTML emails
  "beepr",
  "PHEindicatormethods",
  "skimr",
  "ggtext" # allows addition of HTML color spans in chart title/subtitle text... requires plot.subtitle = ggtext::element_markdown() to be added to the theme to render the HTML
)

# check packages already installed vs. listed for install -----------------

packages_to_download %in% row.names(installed.packages())

row.names(installed.packages()) %in% packages_to_download

# install purrr ----------------------------------------------------------

# #install {purrr} if not already done so
if (!require("purrr")) {
  renv::install(
    "purrr",
    prompt = FALSE
  )
}

library(purrr)

# create function to install packages -------------------------------------

install_vector_of_packages <- function(x) {
  if (!x %in% row.names(installed.packages())) { # Check if already loaded without installing
    # RE: renv::install() : it's a little less typing and can install packages from GitHub, Bioconductor, and more, not just CRAN
    # NB: If you use renv for multiple projects, you'll have multiple libraries, meaning that you'll often need to install the same package in multiple places.
    renv::install(
      x,
      prompt = FALSE
    )
  }
} # [JL] used to have !any(<condition>), but the any() part is not required as purrr::map() takes each individual element of packages_to_download as input into the function i.e. x is not a vector.

# use purrr to map() function and install packages ------------------------

purrr::map(packages_to_download, install_vector_of_packages)

# Load packages --------------------------------------------------------------------

# Loop through packages_to_download and load all libraries
for (i in packages_to_download) {
  if (!require(i, character.only = TRUE)) {
    library(i, character.only = TRUE)
  }
} # [JL] Is it better practice to load in all packages at the beginning, or load in packages only when required?

# check all is installed correctly ----------------------------------------

# Open a command prompt or terminal and type R --version. If it displays the version, R is installed.

# Run quarto check to see if Quarto can find all its dependencies, including R.

# get package references for final bibliography/references --------------------------------------------------

# Get the packages references
knitr::write_bib(c(.packages(), "bookdown"), here::here("packages.bib"))

# merge the zotero references and the packages references
cat(paste("% Automatically generated", Sys.time()),
  "\n% DO NOT EDIT",
  {
    readLines(here("citedrive.bib")) |> # which .bib file is being used?
      paste(collapse = "\n")
  },
  {
    readLines(here("packages.bib")) |>
      paste(collapse = "\n")
  },
  file = here("biblio.bib"),
  sep = "\n"
)

# theme minimal -----------------------------------------------------------

ggplot2::theme_set(ggplot2::theme_minimal())

# knitr options -----------------------------------------------------------

knitr::opts_chunk$set(
  tidy.opts = list(width.cutoff = 60),
  tidy = TRUE,
  strip.white = TRUE,
  out.width = "90%"
)

options(scipen = 999)  # Disable scientific notation

# renv::remove("trelliscopejs")
# 
# renv::install(
#   "AMR",
#   prompt = FALSE
# )
# 
# renv::snapshot()
# 
# renv::status()


