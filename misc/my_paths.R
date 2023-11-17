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

#check .libPaths() details
.libPaths()

#install required packages
if (!require("pacman")) install.packages(c("pacman"), repos = "https://cran.ma.imperial.ac.uk/", type = "win.binary")

pacman::p_load("pacman", "tidyverse", "lubridate", "here", "knitr", "markdown", "quarto", "flextable", "readxl", "readr", "janitor", "skimr", "fontawesome", "beepr", "padr", "yaml", "rsvg")

# #install {renv} if not already done so
if (!require("renv")) install.packages(c("renv"), repos = "https://cran.ma.imperial.ac.uk/", type = "win.binary")

renv::status()

# If you’d like to initialize a project without attempting dependency discovery and installation – that is, you’d prefer to manually install the packages your project requires on your own – you can use renv::init(bare = TRUE) to initialize a project with an empty project library.

# renv::init(bare = TRUE)
# # otherwise
# renv::init()

##optional {renv} snapshot
renv::snapshot(repos = "https://cran.ma.imperial.ac.uk/")

# renv::activate()
# renv::upgrade()

# # restore packages from the lockfile, bypassing the cache
# renv::restore(rebuild = TRUE)

# # re-install a package
# renv::install("renv", rebuild = TRUE)

# # rebuild all packages in the project
# renv::rebuild()
