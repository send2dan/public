
# for one input, create runparams function with one input: origin ------------------------

# create function to run a report against every subcategory of one variable, e.g. origin airport

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

# execute with purrr:map() function

params_origin <- unique(nycflights13::flights$origin)

purrr::map(params_origin, runparams_one_input)

# for two inputs, create runparams function with two inputs: origin and month -------------

# create function to run a report against every subcategory of two variables, e.g. both origin airport and month

runparams_two_inputs <- function(origin, month) {
  quarto::quarto_render(
    "parameterised_quarto_report.qmd",
    output_format = "html",
    execute_params = list(origin = origin, month = month),
    output_file = glue::glue("parameterised_quarto_report_{origin}_{month}.html")
  )
}

# execute with purrr:map2() function

x <- unique(nycflights13::flights$origin)
y <- unique(nycflights13::flights$month)

two_inputs <- tidyr::crossing(x, y)

purrr::map2(two_inputs$x, two_inputs$y,runparams_two_inputs)

#https://stackoverflow.com/questions/18705153/generate-list-of-all-possible-combinations-of-elements-of-vector

#tidyr::expand() can give both combinations of only values that appear in the data

#two_inputs_expand <- tidyr::expand(flights, nesting(origin, month))


