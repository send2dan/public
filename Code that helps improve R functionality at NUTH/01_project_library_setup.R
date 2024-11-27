# For new project collaborators ---------------------------------------------------------

# #install {renv} if not already done so -------------------
if (!require("renv")) {
  install.packages("renv", 
                   repos = "https://packagemanager.posit.co/cran/latest" , # "https://cran.r-project.org/"
                   type = "win.binary"
  )
}

library(renv)

# renv::init(bare = TRUE) to initialize the project with an empty project library. ---------------
init(bare = TRUE, restart = FALSE)

# There may be a message in the console "- One or more packages recorded in the lockfile are not installed." This is to be expected.


# Update options ----------------------------------------------------------

options(
  renv.config.repos.override = "https://packagemanager.posit.co/cran/latest",
  renv.config.install.verbose = TRUE, # This will give more information in the console while installing the R packages, which may give more error details
  renv.config.connect.timeout = 5, # default is 20 seconds
  renv.config.connect.retry = 1, # default is 3
  renv.download.override = utils::download.file
  # renv.download.trace = TRUE # useful for debugging
)

# Sys.setenv(RENV_DOWNLOAD_METHOD = "curl")

# Update settings.json to ignore certain packages during snapshot() -------------------------------

# RE: https://rstudio.github.io/renv/reference/settings.html
# Settings are automatically persisted across project sessions by writing to renv/settings.json. You can also edit this file by hand, but you'll need to restart the session for those changes to take effect.

# Get the current value of a setting with (e.g.)
settings$snapshot.type()
# Set current value of a setting with (e.g. settings$snapshot.type("explicit") )
settings$snapshot.type("implicit")

# ignored.packages
# A vector of packages, which should be ignored when attempting to snapshot the project's private library. Note that if a package has already been added to the lockfile, that entry in the lockfile will not be ignored.
settings$ignored.packages(c("citr", "xts", "zoo", "nycflights13"))
settings$ignored.packages()


# Run snapshot/restore ----------------------------------------------------

if (!file.exists("renv.lock")) {
  renv::snapshot()
} else {
  renv::restore(
    # rebuild = TRUE,
    prompt = FALSE
  )
}

renv::status()
