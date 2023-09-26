library(glue)

#wrap title lengths to a certain number of characters
#https://stackoverflow.com/questions/2631780/set-the-plot-title-to-wrap-around-and-shrink-the-text-to-fit-the-plot
#You have to manually choose the number of characters to wrap at, but the combination of strwrap and paste will do what you want
wrapper <- function(x, ...)
{
  paste(str_wrap(x, ...), collapse = "\n")
}

#e.g. ggtitle(wrapper(my_title, width = 20))

# function to calculate location_code_n -----------------------------------

#function to filter the list of locations by the number of specimens positive in that location_code

# e.g. data_1st |> 
#  location_code_n(75)

location_code_n <- function(x, bc_n) {
  x |> 
    group_by(location_code) |> 
    summarise(n = n()) |> 
    arrange(desc(n)) |> 
    filter(n > bc_n)
}

# function to calculate percentage resistance over time

perc_res_over_time <- function (x, IntrinsicRes, ab, min, time) {
  x %>% 
    filter(!AMR::mo_is_intrinsic_resistant(
      x = as_mo_fullname,
      ab = {{IntrinsicRes}})) |> 
    mutate(new_date = floor_date(receive_date, 
                                 unit = {{time}},
                                 week_start = getOption("lubridate.week.start", 1)),
           year = year(receive_date)) %>% 
    #distinct(new_date, hospital_number, specimen_no, interp .keep_all = TRUE) |> 
    group_by(new_date) |> 
    summarise(r = resistance({{ab}},
                             minimum = {{min}}, 
                             as_percent = FALSE, 
                             only_all_tested = FALSE),
              n = n_sir({{ab}})) |> 
    mutate(r = r *100) |> 
    ptd_spc(value_field = r, date_field = new_date, improvement_direction = "decrease") %>% 
    ptd_create_ggplot(point_size = 2,
                      percentage_y_axis = FALSE,
                      main_title = "SPC chart",
                      x_axis_label = "date",
                      y_axis_label = "distinct patients (n)",
                      fixed_x_axis_multiple = TRUE,
                      fixed_y_axis_multiple = TRUE,
                      x_axis_date_format = "%m/%y",
                      x_axis_breaks = {{time}},
                      y_axis_breaks = NULL,
                      icons_size = 0L,
                      icons_position = c("top right", "bottom right", "bottom left", "top left", "none"),
                      colours = ptd_spc_colours(),
                      theme_override = NULL,
                      break_lines = c("both", "limits", "process", "none"))+
    labs(title = glue("Percentage resistance over time to ", {{IntrinsicRes}}),
         subtitle = glue::glue("First isolate per patient, Q1 2019 onwards\nExcluding organisms intrinsically resistant to ", {{IntrinsicRes}}),
         x = NULL,
         y = "%")
}

# function to create genus_susceptibility ---------------------------------

genus_susceptibility <- function (x, Genus, Antibiotic) {
  x |>  
    #filter(as_mo_genus %in% top_as_mo_genus) |> 
    filter(as_mo_genus == {{Genus}}) |> #only include a specific Genus
    select(year, hospital, as_mo_genus, {{Antibiotic}}) |> #include only certain antibiotics
    group_by(year, as_mo_genus) |> 
    ggplot() + 
    geom_sir(x = "antibiotic", 
             translate_ab = FALSE,
             minimum = 30) + 
    facet_sir(facet = "antibiotic") + # split plots on antibiotic
    scale_sir_colours() + #make R red and S/SI green and I yellow
    scale_y_continuous(limits = c(0, 1),
                       breaks = c(0, 0.5, 1),
                       label = c("0", "50", "100")) + # show percentages on y axis
    coord_flip() +
    labs(title = glue::glue("Susceptibility of ", {{Genus}}, " spp. to\nselect antimicrobials, stratified by year"),
         subtitle = "First isolate per patient, Q1 2019 onwards",
         x = NULL,
         y = "Percentage susceptibility",
         caption = "Calculation of percentage susceptibility requires min. 30 isolates per year")+
    theme(axis.text.y = element_text(),
          axis.text.x = element_text(size = rel(0.9)),
          strip.text.y = element_blank(),
          legend.position = "bottom") + 
    facet_grid(as_mo_genus ~ year)
}

# function to create species_susceptibility ---------------------------------

species_susceptibility <- function (x, Shortname, Antibiotic) {
  x |>  
    #filter(as_mo_genus %in% top_as_mo_genus) |> 
    filter(as_mo_shortname == {{Shortname}}) |> #only include a specific Genus
    select(year, hospital, as_mo_genus, {{Antibiotic}}) |> #include only certain antibiotics
    group_by(year, as_mo_genus) |> 
    ggplot() + 
    geom_sir(x = "antibiotic", 
             translate_ab = FALSE,
             minimum = 30) + 
    facet_sir(facet = "antibiotic") + # split plots on antibiotic
    scale_sir_colours() + #make R red and S/SI green and I yellow
    scale_y_continuous(limits = c(0, 1),
                       breaks = c(0, 0.5, 1),
                       label = c("0", "50", "100")) + # show percentages on y axis
    labs(title = glue::glue("Susceptibility of ", {{Shortname}}, " to\nselect antimicrobials, stratified by year"),
         subtitle = "First isolate per patient, Q1 2019 onwards",
         x = NULL,
         y = "Percentage susceptibility",
         caption = "Calculation of percentage susceptibility requires min. 30 isolates per year")+
    theme(axis.text.y = element_text(),
          axis.text.x = element_text(size = rel(0.9)),
          strip.text.y = element_blank(),
          legend.position = "bottom") + 
    facet_grid(as_mo_genus ~ year)
}

# function to calculate and plot days between event of interest e.g. candidaemia -------------------------

days_between <- function(x, search_criterion, organism_of_interest) {
  x |> 
    #filter(str_detect(organism_code_verbose, "^Candid.*")) |>
    filter({{search_criterion}} == {{organism_of_interest}}) |>
    mutate(new_date = as_date(receive_date),
           year = year(receive_date)) |>
    arrange(new_date) |> 
    distinct(new_date, .keep_all = TRUE) |> 
    mutate(new_date_lag = lag(new_date)) |> 
    select(specimen_no, hospital_number, new_date, new_date_lag) |>
    mutate(new_date_difftime = difftime(new_date, new_date_lag, units = "days")) |> 
    mutate(new_date_difftime_numeric = as.numeric(str_extract(new_date_difftime, "[0-9]+"))) |> 
    ptd_spc(value_field = new_date_difftime_numeric, date_field = new_date, improvement_direction = "increase") %>%
    ptd_create_ggplot(point_size = 2,
                      percentage_y_axis = FALSE,
                      main_title = "SPC chart",
                      x_axis_label = "date",
                      y_axis_label = "distinct patients (n)",
                      fixed_x_axis_multiple = TRUE,
                      fixed_y_axis_multiple = TRUE,
                      x_axis_date_format = "%m/%y",
                      x_axis_breaks = "3 months",
                      y_axis_breaks = NULL,
                      icons_size = 0L,
                      icons_position = c("top right", "bottom right", "bottom left", "top left", "none"),
                      colours = ptd_spc_colours(),
                      theme_override = NULL,
                      break_lines = c("both", "limits", "process", "none"))+
    labs(title = glue::glue("Days since last blood stream infection\ncaused by ", {{organism_of_interest}}),
         subtitle = "First isolate per patient, Q1 2019 onwards",
         x = NULL,
         y = "n")+
    scale_y_continuous(minor_breaks = NULL,
                       breaks = function(x) unique(floor(pretty(seq(0, (max(x) + 1) * 1.1)))))
}

# function to predict AMR rates (amr_predict) -------------------------------------------

amr_predict <- function(x, Gramstain, ab_amr_code, ab_nuth_code, ab_name, model_type) {
  
  x <- x |>
    rename("TZP" = "TAZ") #rename TAZ to TZP to work with AMR package
  
  df <- x |> 
    filter(as_mo_gramstain == {{Gramstain}}) |>  #or simply type  filter(mo_is_gram_negative())
    filter(!AMR::mo_is_intrinsic_resistant(
      x = as_mo_fullname,
      ab = {{ab_amr_code}}))  #code must use TZP code as TAZ not accepted by the AMR::mo_is_intrinsic_resistant() function
  
  df |> 
    resistance_predict(col_ab = {{ab_amr_code}}, 
                       model = {{model_type}},
                       col_date = "receive_date", #column name containing year
                       year_min = 2019, 
                       info = FALSE, 
                       year_max = lubridate::year(Sys.Date())+5,
                       year_every = 0.5, #change number of points on x-axis
                       minimum = 0,
                       I_as_S = TRUE, #TRUE by default to get around issue of SIE being entered as I for e.g. Pseudomonas. Without I_as_S = TRUE, all Pseudomonas will be resistant
                       preserve_measurements = TRUE,
    ) %>%
    ggplot_sir_predict(ribbon = TRUE) +
    coord_cartesian(
      xlim = NULL,
      ylim = c(0, 0.7),
      expand = TRUE,
      default = FALSE,
      clip = "on") +
    labs(title = glue::glue("Predicted AMR rate of ", {{Gramstain}}, " \norganisms to ", {{ab_name}}),
         subtitle = glue::glue("First isolate per patient, Q1 2019 onwards, \nexcluding organisms intrinsically resistant to ", {{ab_name}}),
         #caption = "caption",
         x = "Year",
         y = "Resistance (%)")+ 
    #theme(axis.text.x = element_text(angle = 60, hjust = 1))+ 
    scale_x_continuous(
      breaks = c(2020, 2022, 2024, 2026, 2028),
      label = c("20", "22", "24", "26", "28")
    )
}

# amr_predict_for_mapping for use in map() -------------------------------------------

amr_predict_for_mapping <- function(x, Gramstain, ab_amr_code, ab_nuth_code, ab_name, model_type) {
  
  x <- x |>
    rename("TZP" = "TAZ") #rename TAZ to TZP to work with AMR package
  
  df <- x |> 
    filter(as_mo_gramstain == {{Gramstain}}) |>  #or simply type  filter(mo_is_gram_negative())
    filter(!AMR::mo_is_intrinsic_resistant(
      x = as_mo_fullname,
      ab = {{ab_amr_code}}))  #code must use TZP code as TAZ not accepted by the AMR::mo_is_intrinsic_resistant() function
  
  df |> 
    resistance_predict(col_ab = {{ab_amr_code}}, 
                       model = {{model_type}},
                       col_date = "receive_date", #column name containing year
                       year_min = 2019, 
                       info = FALSE, 
                       year_max = lubridate::year(Sys.Date())+5,
                       year_every = 0.5, #change number of points on x-axis
                       minimum = 0,
                       I_as_S = TRUE, #TRUE by default to get around issue of SIE being entered as I for e.g. Pseudomonas. Without I_as_S = TRUE, all Pseudomonas will be resistant
                       preserve_measurements = TRUE,
    )  |> 
    ggplot_sir_predict(ribbon = TRUE) +
    labs(title = NULL,
         #caption = "caption",
         subtitle = wrapper({{ab_name}}, 10), #use custom function wrapper() to wrap text of e.g. subtitle to a certain number of characters
         x = NULL,
         y = NULL)+
    theme(plot.subtitle = element_text(size = 8))+ #change e.g. subtitle font size / text size
    coord_cartesian(
      xlim = NULL,
      ylim = c(0, 0.7),
      expand = TRUE,
      default = FALSE,
      clip = "on")+ 
    #theme(axis.text.x = element_text(angle = 60, hjust = 1))+ 
    scale_x_continuous(
      breaks = c(2020, 2022, 2024, 2026, 2028),
      label = c("20", "22", "24", "26", "28")
    )
}

# function to predict AMR rates (amr_predict) stratified by nesting_crit ----------------------

amr_predict_chart_nested <- function(x, Gramstain, ab_amr_code, nesting_crit, nesting_name, ab_nuth_code, ab_name, model_type, n_bc, nrow, plot_subtitle) {
  
  x <- x |>
    rename("TZP" = "TAZ") #rename TAZ to TZP to work with AMR package
  
  #filter df
  nested_df <- x |> 
    filter(as_mo_gramstain == {{Gramstain}}) |>  #or simply type  filter(mo_is_gram_negative())
    filter(!AMR::mo_is_intrinsic_resistant(
      x = as_mo_fullname,
      ab = {{ab_amr_code}})) |>  #code must use TZP code as TAZ not accepted by the AMR::mo_is_intrinsic_resistant() function
    filter(!year(receive_date) == "2023") |> #remove 2023 as it's not yet complete
    group_nest({{nesting_crit}}) #group_nest 
  
  #get top 5 groups in df
  top_nested <- x |> 
    group_by({{nesting_crit}}) |> 
    summarise(n = n()) |> 
    arrange(desc(n)) |>
    filter(n > {{n_bc}}) |> #keep only nesting_crit with more than x positive 'first' isolates
    pull({{nesting_crit}}) 
  
  filtered_nested_df <- nested_df |>
    filter({{nesting_crit}} %in% top_nested) |>  #filter only nested variables with large volumes of data
    filter(!is.na({{nesting_crit}}))  #remove 'empty' rows
  
  #nested df of models
  output <- filtered_nested_df |> 
    mutate(
      res_pred = map2(.x = data,
                      .y = filtered_nested_df[[1]],
                      .f = ~resistance_predict(.x,
                                               col_ab = {{ab_nuth_code}},
                                               model = {{model_type}},
                                               col_date = "receive_date", #column name containing year
                                               year_min = 2019, 
                                               info = FALSE, 
                                               lubridate::year(Sys.Date())+2, #how many years into the future do we want to look?
                                               year_every = 0.5, #change number of points on x-axis
                                               minimum = 0,
                                               I_as_S = TRUE, #TRUE by default to get around issue of SIE being entered as I for e.g. Pseudomonas. Without I_as_S = TRUE, all Pseudomonas will be resistant
                                               preserve_measurements = TRUE) |> 
                        ggplot_sir_predict()+
                        # theme(axis.title.x=element_blank(),
                        #       axis.text.x=element_blank(),
                        #       axis.ticks.x=element_blank(),
                        #       axis.title.y=element_blank(),
                        #       axis.text.y=element_blank(),
                        #       axis.ticks.y=element_blank())))
                        # scale_y_continuous(name=NULL,
                        #                    labels = scales::label_percent(),
                        #                    breaks =scales::pretty_breaks(4)) + #pretty scales as per https://stackoverflow.com/questions/73676811/pretty-breaks-on-secondary-axis-negative-values-doesnt-show
                        labs(title = NULL,
                             #caption = "caption",
                             subtitle = wrapper(.y, 10), #use custom function wrapper() to wrap text of e.g. subtitle to a certain number of characters
                             x = NULL,
                             y = NULL)+
                        #theme(axis.text.x = element_text(angle = 60, hjust = 1))+ 
                        scale_x_continuous(
                          breaks = c(2020, 2022, 2024, 2026, 2028),
                          label = c("20", "22", "24", "26", "28")
                        )+
                        theme(plot.subtitle = element_text(size = 8))+ #change e.g. subtitle font size / text size
                        coord_cartesian(
                          xlim = NULL,
                          ylim = c(0, 0.7),
                          expand = TRUE,
                          default = FALSE,
                          clip = "on"
                        )))
  
  patchwork::wrap_plots(output$res_pred, 
                        nrow = {{nrow}}) + 
    patchwork::plot_layout(guides = 'collect')+
    patchwork::plot_annotation(
      title = glue::glue("Predicted resistance of ", {{Gramstain}}, " organisms to \n", {{ab_name}}, ", stratified by ", {{nesting_name}}),
      subtitle = {{plot_subtitle}},
      #tag_levels = 'I',
      caption = glue::glue("First isolate per patient, Q1 2019 onwards, \nexcluding organisms intrinsically resistant to ", {ab_name})
    ) +
    xlab("year")+
    ylab("% resistance")
  
}
