
# From https://github.com/wjschne/spiro/blob/87f73ec37ceb0a7a9d09856ada8ae28d587a2ebd/R/spirograph.R
# Adapted under the CC0 1.0 Universal license: https://github.com/wjschne/spiro/blob/87f73ec37ceb0a7a9d09856ada8ae28d587a2ebd/LICENSE.md
spirograph_points <- function(fixed_radius, cycling_radius) {
  t <- seq(1, 30 * pi, length.out = 1e4)
  diff <- (fixed_radius - cycling_radius)
  ratio <- diff / cycling_radius
  x <- diff * cos(t) + cos(t * ratio)
  y <- diff * sin(t) - sin(t * ratio)
  # ADJUST SLOWNESS AS YOU LIKE:
  Sys.sleep(5)
  tibble(x = x, y = y, fixed_radius = fixed_radius, cycling_radius = cycling_radius)
  # Note that 'fixed_radius' and 'cycling_radius' areincluded
  # From manual: " It is good practice to proactively append this metadata to each branch"
}

plot_spirographs <- function(points) {
  label <- "fixed_radius = %s, cycling_radius = %s"
  points$parameters <- sprintf(label, points$fixed_radius, points$cycling_radius)
  ggplot(points) +
    geom_point(aes(x = x, y = y, color = parameters), size = 0.1) +
    facet_wrap(~parameters) +
    theme_gray(16) +
    guides(color = "none")
}

spirograph_points_fromdf <- function(data, sleep_length = 0){
  purrr::map2_dfr(data$fixed_radius, 
                  data$cycling_radius, 
                  spirograph_points)
}
