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

# #activate {renv}
if (!require("AMR")) install.packages(c("AMR"), repos = "https://cran.ma.imperial.ac.uk/", type = "win.binary")

# renv::init()
# renv::activate()
# renv::upgrade()

pacman::p_load("pacman", "tidyverse", "lubridate", "here", "knitr", "markdown", "quarto", "flextable", "readxl", "readr", "janitor", "skimr", "fontawesome", "beepr")

##optional {renv} snapshot
# renv::snapshot(repos = "https://cran.ma.imperial.ac.uk/")

#check .libPaths() details
.libPaths()

renv::status()
