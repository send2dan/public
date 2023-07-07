#set global options to use "wininet" as download method & "https://cran.ma.imperial.ac.uk/" as repos
options(download.file.method = "wininet", repos = "https://cran.ma.imperial.ac.uk/")

#set repos for {renv} and disable download from MRAN:
options(renv.config.repos.override = "https://cran.ma.imperial.ac.uk/",
        renv.config.mran.enabled = FALSE)

#If you find that downloads work outside of {renv} projects, but not within {renv} projects, you may need to tell renv to use the same download file method that R has been configured to use. You can check which download method R is currently configured to use with:
getOption("download.file.method")

#And the downloader currently used by {renv} can be queried with:
renv:::renv_download_method()

#You can force {renv} to use the same download method as R by setting:
Sys.setenv(RENV_DOWNLOAD_METHOD = getOption("download.file.method"))

#recheck downloader currently used by {renv}:
renv:::renv_download_method()

#activate {renv}
if (!require("renv")) install.packages("renv", repos = "https://cran.ma.imperial.ac.uk/", type = "win.binary")

# renv::init()
renv::activate()

# #load ggiraph package for interactive ggplot
if (!require("ggiraph")) install.packages("ggiraph", repos = "https://cran.ma.imperial.ac.uk/", type = "win.binary")

# #install and load packages required by project using {pacman}
if (!require("pacman")) install.packages("pacman", repos = "https://cran.ma.imperial.ac.uk/", type = "win.binary")

# #install and load devtools
if (!require("devtools")) install.packages("devtools", repos = "https://cran.ma.imperial.ac.uk/", type = "win.binary")

# #install and load devtools
if (!require("gghighlight")) install.packages("gghighlight", repos = "https://cran.ma.imperial.ac.uk/", type = "win.binary")

pacman::p_load("flextable", "here", "readxl", "readr", "tidyverse", "lubridate", "janitor", "AMR", "bibtex", "bookdown", "cleaner", "DiagrammeR", "fuzzyjoin", "ggsurvfit", "gtsummary", "kableExtra", "NHSRplotthedots", "pacman", "padr", "patchwork", "PHEindicatormethods", "qicharts2", "quarto", "markdown", "ragg", "RefManageR", "runcharter", "sciplot", "skimr", "svglite", "thematic", "tidycmprsk", "tidylog", "tidytext", "whisker", "xts", "zoo", "RSQLite", "lattice", "mgcv", "miniUI", "devtools", "Rdiagnosislist", "ggiraph", "gghighlight", "scales", "ggtext")

##optional {renv} snapshot
# renv::snapshot(repos = "https://cran.ma.imperial.ac.uk/")

#check .libPaths() details
.libPaths()

renv::status()
