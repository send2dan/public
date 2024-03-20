# explaining renv ---------------------------------------------------------
#https://rstudio.github.io/renv/articles/renv.html#collaboration

# #install {renv} if not already done so
if (!require("renv")) install.packages(c("renv"), repos = "https://cran.ma.imperial.ac.uk/", type = "win.binary")

#set repos for {renv} and disable download from MRAN:
options(renv.config.repos.override = "https://cran.ma.imperial.ac.uk/",
        renv.config.mran.enabled = FALSE)

# use Windows' internal download machinery, rather than R's bundled libcurl implementation (https://rstudio.github.io/renv/articles/package-install.html)
#set global options to use "wininet" as download method & "https://cran.ma.imperial.ac.uk/" as repos
options(download.file.method = "wininet", repos = "https://cran.ma.imperial.ac.uk/")

#If you find that downloads work outside of {renv} projects, but not within {renv} projects, you may need to tell renv to use the same download file method that R has been configured to use. You can check which download method R is currently configured to use with:
getOption("download.file.method")

#You can force {renv} to use the same download method as R by setting:
Sys.setenv(RENV_DOWNLOAD_METHOD = getOption("download.file.method"))

#And the downloader currently used by {renv} can be queried with:
renv:::renv_download_method()

#check .libPaths() details
.libPaths()

# if this is your first time cloning this project:

#1
# renv::restore(repos = "https://cran.ma.imperial.ac.uk/", prompt = FALSE)

#2
# # initialize a new project (with an empty R library)
# renv::init(bare = TRUE, restart = FALSE)

packages_to_download <- c(
                          "tidyverse",
                          "lubridate",
                          "here",
                          "knitr",
                          "markdown",
                          "quarto",
                          "flextable",
                          "readxl",
                          "readr",
                          "janitor",
                          "skimr",
                          "fontawesome",
                          "beepr",
                          "yaml",
                          "DT",
                          #  "padr",
                          #  "rsvg",
                          #  "AMR",
                          #  "excel.link",
                          #  "NHSRplotthedots",
                          #  "PHEindicatormethods",
                          "dotenv"
                          )
                        

# Define a function to check and install packages
install_if_missing <- function(package_name, repo = "https://cran.ma.imperial.ac.uk/", type = "win.binary") {
  # Use a more reliable way to check for installation
  if (!package_name %in% rownames(installed.packages())) {
    # Install the package with informative messages
    install.packages(package_name, repos = repo, type = type)
    message(paste0("Package '", package_name, "' installed successfully."))
  } else {
    message(paste0("Package '", package_name, "' is already installed."))
  }
}

# Loop through packages_to_download and install missing packages
for (package_name in packages_to_download) {
  # Pass repo and type arguments if needed
  install_if_missing(package_name, repo = "https://cran.ma.imperial.ac.uk/", type = "win.binary")  # Example
}

# Loop through packages_to_download and load all libraries
for (package_name in packages_to_download) {
  if (!require(package_name, character.only = TRUE)) {
    library(package_name, character.only = TRUE)
  }
}

#install individual packages
# if (!require("curl")) install.packages(c("curl"), repos = "https://cran.ma.imperial.ac.uk/", type = "win.binary")

renv::status()

# Use `renv::dependencies()` to see where this package is used in your project.
proj_dep <- renv::dependencies() 
proj_dep |> 
  dplyr::as_tibble() |> 
  print(n=100)

#Use `renv::snapshot()` to create a lockfile.
renv::snapshot(repos = "https://cran.ma.imperial.ac.uk/")
