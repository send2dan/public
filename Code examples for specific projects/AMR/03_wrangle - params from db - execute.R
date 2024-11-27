# quarto::quarto_render() --------------------------------------------------

# https://meghan.rbind.io/blog/quarto-pdfs/ params function ---------------

# runpdfs <- function(species, year) {
#   quarto::quarto_render(
#     "penguins.qmd",
#     output_format = "pdf",
#     execute_params = list(species = species, year = year),
#     output_file = glue::glue("{species} {year}.pdf")
#   )
# }
# 
# purrr::map2(unique(penguins$species), unique(penguins$year),
#             runpdfs)

# # directorate -----------------------------------------------------------------
# 
# #create runparams function with one input: directorate
# runparams <- function(directorate) {
#   quarto::quarto_render(
#     "BC_AST_prediction_mapped_functions_parameterised.qmd",
#     output_format = "html",
#     execute_params = list(directorate = directorate),
#     output_file = glue::glue("BC_AST_prediction_mapped_functions_parameterised_{directorate}.html")
#   )
# }
# 
# # #test runparams function with one input: directorate
# runparams(directorate = "Medicine")
# 
# params_directorate <- data_clean |>
#   filter(!is.na(directorate)) |>
#   distinct(hospital_number, specimen_no, .keep_all = TRUE) |>
#   count(directorate) |>
#   arrange(desc(n)) |>
#   filter(n >200) |> #filter for more than 200 specimens
#   pull(directorate)
# 
# purrr::map(params_directorate, runparams)

# directorate_recoded -----------------------------------------------------------------

#create runparams function with one input: directorate_recoded
runparams <- function(directorate_recoded) {
  quarto::quarto_render(
    "BC_AST_prediction_mapped_functions_parameterised.qmd",
    output_format = "html",
    execute_params = list(directorate_recoded = directorate_recoded),
    output_file = glue::glue("BC_AST_prediction_mapped_functions_parameterised_{directorate_recoded}.html")
  )
}

# # test runparams function with one input: directorate_recoded
# runparams(directorate_recoded = "Medicine")

params_directorate_recoded <- data_clean |>
  filter(!is.na(directorate_recoded)) |>
  distinct(hospital_number, specimen_no, .keep_all = TRUE) |>
  count(directorate_recoded) |>
  arrange(desc(n)) |>
  filter(n >200) |> #filter for more than 200 specimens
  pull(directorate_recoded)

purrr::map(params_directorate_recoded, runparams)

# location_code -----------------------------------------------------------------

#create runparams function with one input: location_code
runparams <- function(location_code) {
  quarto::quarto_render(
    "BC_AST_prediction_mapped_functions_parameterised.qmd",
    output_format = "html",
    execute_params = list(location_code = location_code),
    output_file = glue::glue("BC_AST_prediction_mapped_functions_parameterised_{location_code}.html")
  )
}

# # test runparams function with one input: location_code
# runparams(location_code = "NCCC32")

params_location_code <- data_clean |>
  filter(!is.na(location_code)) |>
  distinct(hospital_number, specimen_no, .keep_all = TRUE) |>
  count(location_code) |>
  arrange(desc(n)) |>
  head(10) |> 
  pull(location_code)

purrr::map(params_location_code, runparams)

# elderly care ------------------------------------------------------

#create runparams function with one input: location_code
runparams <- function(elderly_care) {
  quarto::quarto_render(
    "BC_AST_prediction_mapped_functions_parameterised.qmd",
    output_format = "html",
    execute_params = list(elderly_care = elderly_care),
    output_file = glue::glue("BC_AST_prediction_mapped_functions_parameterised_elderly_care_{elderly_care}.html")
  )
}

# #add a column for elderly care at FH
# 
# data_clean <- data_clean |>
#   mutate(elderly_care = if_else(str_detect(location_code, "FH09|FH13|FH15|FH17|FH18|RV31") & age >65, true = TRUE, false = FALSE))
# 
# data_clean_sens <- data_clean_sens |>
#   mutate(elderly_care = if_else(str_detect(location_code, "FH09|FH13|FH15|FH17|FH18|RV31") & age >65, true = TRUE, false = FALSE))
# 
# data_1st <- data_1st |>
#   mutate(elderly_care = if_else(str_detect(location_code, "FH09|FH13|FH15|FH17|FH18|RV31") & age >65, true = TRUE, false = FALSE))

# #check which wards are included
# data_clean |>
#   distinct(hospital_number, .keep_all = TRUE) |>
#   filter(elderly_care == TRUE) |>
#   count(location_code)

params_elderly_care <- data_clean |>
  distinct(elderly_care) |>
  pull(elderly_care)

# # test runparams function with one input: location_code
# runparams(elderly_care = "1")

purrr::map(params_elderly_care, runparams)

# quarto render BC_AST_prediction_mapped_functions_parameterised.qmd -P elderly_care:TRUE

# paediatric -----------------------------------------------------------------

#create runparams function with one input: paediatric
runparams <- function(paediatric) {
  quarto::quarto_render(
    "BC_AST_prediction_mapped_functions_parameterised.qmd",
    output_format = "html",
    execute_params = list(paediatric = paediatric),
    output_file = glue::glue("BC_AST_prediction_mapped_functions_parameterised_paediatric_{paediatric}.html")
  )
}

# #test runparams function with one input: paediatric
# runparams(paediatric = 1)

params_paediatric <- data_clean |>
  filter(!is.na(paediatric)) |>
  distinct(hospital_number, specimen_no, .keep_all = TRUE) |>
  count(paediatric) |>
  arrange(desc(n)) |>
  filter(n >100) |> #filter for more than 100 specimens
  pull(paediatric)

# # paeds = 1
# data_clean |>
#   filter(!is.na(paediatric)) |>
#   distinct(hospital_number, specimen_no, .keep_all = TRUE) |>
#   filter(paediatric == 1) |>
#   glimpse()

purrr::map(params_paediatric, runparams)

# diabetic -----------------------------------------------------------------

#create runparams function with one input: diabetic
runparams <- function(diabetic) {
  quarto::quarto_render(
    "BC_AST_prediction_mapped_functions_parameterised.qmd",
    output_format = "html",
    execute_params = list(diabetic = diabetic),
    output_file = glue::glue("BC_AST_prediction_mapped_functions_parameterised_diabetic_{diabetic}.html")
  )
}

#test runparams function with one input: diabetic
runparams(diabetic = 1)

params_diabetic <- data_clean |>
  filter(!is.na(diabetic)) |>
  distinct(hospital_number, specimen_no, .keep_all = TRUE) |>
  count(diabetic) |>
  arrange(desc(n)) |>
  filter(n >100) |> #filter for more than 100 specimens
  pull(diabetic)

# # paeds = 1
# data_clean |>
#   filter(!is.na(diabetic)) |>
#   distinct(hospital_number, specimen_no, .keep_all = TRUE) |>
#   filter(diabetic == 1) |>
#   glimpse()

purrr::map(params_diabetic, runparams)

# urology -----------------------------------------------------------------

#create runparams function with one input: urology
runparams <- function(urology) {
  quarto::quarto_render(
    "BC_AST_prediction_mapped_functions_parameterised.qmd",
    output_format = "html",
    execute_params = list(urology = urology),
    output_file = glue::glue("BC_AST_prediction_mapped_functions_parameterised_urology_{urology}.html")
  )
}

#test runparams function with one input: urology
runparams(urology = 1)

params_urology <- data_clean |>
  filter(!is.na(urology)) |>
  distinct(hospital_number, specimen_no, .keep_all = TRUE) |>
  count(urology) |>
  arrange(desc(n)) |>
  filter(n >100) |> #filter for more than 100 specimens
  pull(urology)

# # paeds = 1
# data_clean |>
#   filter(!is.na(urology)) |>
#   distinct(hospital_number, specimen_no, .keep_all = TRUE) |>
#   filter(urology == 1) |>
#   glimpse()

purrr::map(params_urology, runparams)

# renal_chd -----------------------------------------------------------------

#create runparams function with one input: renal_chd
runparams <- function(renal_chd) {
  quarto::quarto_render(
    "BC_AST_prediction_mapped_functions_parameterised.qmd",
    output_format = "html",
    execute_params = list(renal_chd = renal_chd),
    output_file = glue::glue("BC_AST_prediction_mapped_functions_parameterised_renal_chd_{renal_chd}.html")
  )
}

#test runparams function with one input: renal_chd
runparams(renal_chd = 1)

params_renal_chd <- data_clean |>
  filter(!is.na(renal_chd)) |>
  distinct(hospital_number, specimen_no, .keep_all = TRUE) |>
  count(renal_chd) |>
  arrange(desc(n)) |>
  filter(n >100) |> #filter for more than 100 specimens
  pull(renal_chd)

# # paeds = 1
# data_clean |>
#   filter(!is.na(renal_chd)) |>
#   distinct(hospital_number, specimen_no, .keep_all = TRUE) |>
#   filter(renal_chd == 1) |>
#   glimpse()

purrr::map(params_renal_chd, runparams)

