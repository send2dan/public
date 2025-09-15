
# wrangle_AMR_predict

# find top antibiotics ----------------------------------------------------

top_ab <- data_1st |>
  glimpse() |> 
  # dplyr::mutate(across(where(AMR::is.sir), AMR::as.sir),
  #               across(c(date_of_birth, receive_date), lubridate::as_date)) |> 
  # filter(as_mo_genus == "Klebsiella") |>
  #filter(as_mo_gramstain == "Gram-negative") |>
  select(where(AMR::is.sir)) |>  #to get antibiotic names and test results in long rather than wide format |> 
  #janitor::remove_empty(which = c("rows", "cols"), quiet = TRUE) |> 
  rename("TZP" = "TAZ") |>  #rename TAZ to TZP to work with AMR package 
  skimr::skim()

# choose gram neg ab ------------------------------------------------------

gram_neg_ab <- c("AMX", "AMC", "TZP", "CXM", "CAZ", "ATM", "CIP", "GEN", "SXT", "CHL")

gram_neg_ab_tibble <- top_ab |> 
  filter(skim_variable %in% gram_neg_ab) |> 
  select(skim_variable, sir.ab_name) |> 
  arrange(sir.ab_name)

# choose kleb ab ------------------------------------------------------

kleb_ab <- c("AMC", "TZP", "CXM", "CAZ", "ATM", "CIP", "GEN", "SXT", "CHL")

kleb_ab_tibble <- top_ab |> 
  filter(skim_variable %in% kleb_ab) |> 
  select(skim_variable, sir.ab_name) |> 
  arrange(sir.ab_name)

# choose gram neg urine ab ------------------------------------------------------

gram_neg_urine_ab <- c("AMX", "AMC", "TZP", "CXM", "LEX", "ATM", "CIP", "GEN", "SXT", "TMP", "FOS", "NIT")

gram_neg_urine_ab_tibble <- top_ab |> 
  filter(skim_variable %in% gram_neg_urine_ab) |> 
  select(skim_variable, sir.ab_name) |> 
  arrange(sir.ab_name)

# choose gram pos ab ------------------------------------------------------

gram_pos_ab <- c("AMX", "FLC", "DOX", "ERY", "CLI", "SXT", "GEN")

# "AMX", "FLC", "ERY", "CLI", "DOX", "SXT", "GEN", "LNZ", "TEC", "DAP"

gram_pos_ab_tibble <- top_ab |> 
  filter(skim_variable %in% gram_pos_ab) |> 
  select(skim_variable, sir.ab_name) |> 
  arrange(sir.ab_name)

# # choose antifungals  ------------------------------------------------------
# 
# antifungal_antimicrobials <- data_1st |> 
#   select(ab_class("antifungal")) |> 
#   colnames()
# 
# antifungal_antimicrobials_list <- top_ab |> 
#   filter(skim_variable %in% antifungal_antimicrobials) |> 
#   select(skim_variable, sir.ab_name) |> 
#   arrange(sir.ab_name)


# search for antimicrobials -----------------------------------------------

# #antimicrobials in data_1st
# data_1st |> 
#   select(AMK:CRB) |> 
#   colnames()
# 
# #test antimicrobials in data_1st
# data_1st |> 
#   select(LNZ) |> 
#   head(10)
# 
# #test antimicrobials in AMR
# AMR::antimicrobials |> 
#   select(ab, name) |> 
#   filter(ab == "LNZ")
# head(10)
