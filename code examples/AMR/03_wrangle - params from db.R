# params / parameterised reporting -------------------------------------------------

# Now, by default, this output looks the same as the last time. However, when we run quarto render now, we can either pass parameters on the command line, for instance using:

# quarto render BC_AST_results_parameterised_from_db.qmd -P location_code:XXXXX

# params / parameterised reporting -------------------------------------------------

# quarto render BC_AST_results_parameterised_from_db.qmd -P PARAMETER_NAME:XXXXX


# directorate -------------------------------------------------------------

if (!is.na(params$directorate) && params$directorate != "NA") {
  data_clean <- data_clean[data_clean$directorate == params$directorate, ]
  data_clean_sens <- data_clean_sens[data_clean_sens$directorate == params$directorate, ]
  data_1st <- data_1st[data_1st$directorate == params$directorate, ]
}
if (nrow(data_clean) == 0) {
  stop("Invalid selection. Did you misspell `directorate`?")
}


#  directorate_recoded ----------------------------------------------------

if (!is.na(params$directorate_recoded) && params$directorate_recoded != "NA") {
  data_clean <- data_clean[data_clean$directorate_recoded == params$directorate_recoded, ]
  data_clean_sens <- data_clean_sens[data_clean_sens$directorate_recoded == params$directorate_recoded, ]
  data_1st <- data_1st[data_1st$directorate_recoded == params$directorate_recoded, ]
}
if (nrow(data_clean) == 0) {
  stop("Invalid selection. Did you misspell `directorate_recoded`?")
}


# location_code -----------------------------------------------------------

if (!is.na(params$location_code) && params$location_code != "NA") {
  data_clean <- data_clean[data_clean$location_code == params$location_code, ]
  data_clean_sens <- data_clean_sens[data_clean_sens$location_code == params$location_code, ]
  data_1st <- data_1st[data_1st$location_code == params$location_code, ]
}
if (nrow(data_clean) == 0) {
  stop("Invalid selection. Did you misspell `location_code`?")
}


# paediatric --------------------------------------------------------------

if (!is.na(params$paediatric) && params$paediatric != "NA") {
  data_clean <- data_clean[data_clean$paediatric == params$paediatric, ]
  data_clean_sens <- data_clean_sens[data_clean_sens$paediatric == params$paediatric, ]
  data_1st <- data_1st[data_1st$paediatric == params$paediatric, ]
}
if (nrow(data_clean) == 0) {
  stop("Invalid selection. Did you misspell `paediatric`?")
}

# diabetic --------------------------------------------------------------

if (!is.na(params$diabetic) && params$diabetic != "NA") {
  data_clean <- data_clean[data_clean$diabetic == params$diabetic, ]
  data_clean_sens <- data_clean_sens[data_clean_sens$diabetic == params$diabetic, ]
  data_1st <- data_1st[data_1st$diabetic == params$diabetic, ]
}
if (nrow(data_clean) == 0) {
  stop("Invalid selection. Did you misspell `diabetic`?")
}

# urology --------------------------------------------------------------

if (!is.na(params$urology) && params$urology != "NA") {
  data_clean <- data_clean[data_clean$urology == params$urology, ]
  data_clean_sens <- data_clean_sens[data_clean_sens$urology == params$urology, ]
  data_1st <- data_1st[data_1st$urology == params$urology, ]
}
if (nrow(data_clean) == 0) {
  stop("Invalid selection. Did you misspell `urology`?")
}

# renal_chd --------------------------------------------------------------

if (!is.na(params$renal_chd) && params$renal_chd != "NA") {
  data_clean <- data_clean[data_clean$renal_chd == params$renal_chd, ]
  data_clean_sens <- data_clean_sens[data_clean_sens$renal_chd == params$renal_chd, ]
  data_1st <- data_1st[data_1st$renal_chd == params$renal_chd, ]
}
if (nrow(data_clean) == 0) {
  stop("Invalid selection. Did you misspell `renal_chd`?")
}


# elderly_care ------------------------------------------------------------

# #add a column for elderly care at FH
# data_clean <- data_clean |> 
#   mutate(elderly_care = if_else(str_detect(location_code, "FH09|FH13|FH15|FH17|FH18|RV31") & age >65, true = TRUE, false = FALSE))
# 
# data_clean_sens <- data_clean_sens |> 
#   mutate(elderly_care = if_else(str_detect(location_code, "FH09|FH13|FH15|FH17|FH18|RV31") & age >65, true = TRUE, false = FALSE))
# 
# data_1st <- data_1st |> 
#   mutate(elderly_care = if_else(str_detect(location_code, "FH09|FH13|FH15|FH17|FH18|RV31") & age >65, true = TRUE, false = FALSE))

if (!is.na(params$elderly_care) && params$elderly_care != "NA") {
  data_clean <- data_clean[data_clean$elderly_care == params$elderly_care, ]
  data_clean_sens <- data_clean_sens[data_clean_sens$elderly_care == params$elderly_care, ]
  data_1st <- data_1st[data_1st$elderly_care == params$elderly_care, ]
}
if (nrow(data_clean) == 0) {
  stop("Invalid selection. Did you misspell `elderly_care`?")
}

# year --------------------------------------------------------------------
# 
# if (!is.na(params$year) && params$year != "NA") {
#   data_clean <- data_clean[data_clean$year == params$year, ]
#   data_clean_sens <- data_clean_sens[data_clean_sens$year == params$year, ]
#   data_1st <- data_1st[data_1st$year == params$year, ]
# }
# if (nrow(data_clean) == 0) {
#   stop("Invalid selection. Did you misspell `year`?")
# }
# 
# 



