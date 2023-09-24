
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

params_origin <- unique(flights$origin)

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
# https://stackoverflow.com/questions/54256790/is-there-a-way-i-can-recycle-elements-of-the-shorter-list-in-purrr-map2-or-pur

x <- unique(flights$origin)
y <- unique(flights$month)
l <- max(length(y), length(x))
purrr::map2(rep(x,len = l), rep(y,len = l),runparams_two_inputs)

