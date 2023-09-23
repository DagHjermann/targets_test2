# _targets.R
library(dplyr)
library(ggplot2)
library(targets)
library(tibble)

# install.packages("tarchetypes")
library(tarchetypes)

source("functions.R")

#
# example 1: using 'group_by' and 'tar_group' (from 'targets' package)
#

# list(
#   tar_target(
#     points,
#     bind_rows(
#       spirograph_points(3, 9),
#       spirograph_points(7, 2)
#     ) %>%
#       group_by(fixed_radius, cycling_radius) %>%
#       tar_group(),
#     iteration = "group"
#   ),
#   tar_target(
#     single_plot,
#     plot_spirographs(points),
#     pattern = map(points),
#     iteration = "list"
#   )
# )

#
# example 2: using 'tar_group_by' (from 'tarchetypes' package)
#

# 
# list(
#   tar_group_by(
#     points,
#     bind_rows(
#       spirograph_points(3, 9),
#       spirograph_points(7, 2)
#     ),
#     fixed_radius, cycling_radius
#   ),
#   tar_target(
#     single_plot,
#     plot_spirographs(points),
#     pattern = map(points),
#     iteration = "list"
#   )
# )


#
# example 3: using 'tar_group_by' (from 'tarchetypes' package),
#   but also reading parameters from file
# Hoping that this would enable me to rerun just the parameters that have changed.
#   Tested by adding a 'sleep_length' parameter, see 
# 1. Set 'spirograph_points' to sleep for 5 seconds for each run (see code in 'functions' file)    
# 2. Run tar_make(), takes 10 seconds extra   
# 3. Opened data.csv, changed ONE number, saved
# 4. tar_visnetwork() shows invalidated parts
# 5. tar_make() - does it make 5 or 10 seconds? Seems like 10 seconds.... 
#

# That is, even if one changes only one line, target_make seems to run both lines again (doesn't go faster)  

library(purrr)

list(
  tar_target(file, "data.csv", format = "file"),
  tar_target(parameter_data, read.csv(file)),
  tar_group_by(
    points,
    spirograph_points_fromdf(parameter_data),
    fixed_radius, cycling_radius
  ),
  tar_target(
    single_plot,
    plot_spirographs(points),
    pattern = map(points),
    iteration = "list"
  )
)
