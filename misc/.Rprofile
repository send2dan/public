source("renv/activate.R")

options(max.print = 40)
options(connectionObserver = NULL)
# ^ connectionObserver at work just gets in the way.
options(tidyverse.quiet = TRUE)
options(styler.cache_root = "styler-perm")

setHook("rstudio.sessionInit", function(newSession) {
  rstudioapi::writeRStudioPreference("save_workspace", "never")
  rstudioapi::writeRStudioPreference("always_save_history", FALSE)
  rstudioapi::writeRStudioPreference("save_files_before_build", TRUE)
}, action = "append")
