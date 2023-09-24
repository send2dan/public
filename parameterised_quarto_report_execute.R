
# for one input, create runparams function with one input: origin ------------------------

runparams_one_input <- function(origin) {
  quarto::quarto_render(
    "parameterised_quarto_report.qmd",
    output_format = "html",
    execute_params = list(origin = origin),
    output_file = glue::glue("parameterised_quarto_report_{origin}.html")
  )
}

# to run a single report

runparams_one_input(origin = "JFK")

# to run a report against every subcategory of a variable, e.g. origin airport

params_origin <- unique(flights$origin)

# execute with purrr:map() function

purrr::map(params_origin, runparams_one_input)

# for two inputs, create runparams function with two inputs: origin and month -------------

runparams_two_inputs <- function(origin, month) {
  quarto::quarto_render(
    "parameterised_quarto_report.qmd",
    output_format = "html",
    execute_params = list(origin = origin, month = month),
    output_file = glue::glue("parameterised_quarto_report_{origin}_{month}.html")
  )
}

# to run a report against every subcategory of two variables, e.g. both origin airport and month

params_origin <- unique(flights$origin)

params_month <- unique(flights$month)

# execute with purrr:map2() function

purrr::map2(params_origin, params_month, runparams_two_inputs)


