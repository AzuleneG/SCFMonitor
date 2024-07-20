OptiConvergenceMonitor <- function(directory) {
  Glog <- read_file(directory) %>%
    str_split("\n") %>%
    as.data.frame() %>%
    as_tibble() %>%
    rename(rawdat = starts_with("c")) %>%
    filter(
      str_detect(rawdat, "^ Maximum Displacement") |
        str_detect(rawdat, "^ Maximum Force") |
        str_detect(rawdat, "^ RMS     Force") |
        str_detect(rawdat, "^ RMS     Displacement")
    ) %>%
    mutate(rawdat = str_trim(rawdat))
  
  Glog <- Glog %>%
    mutate(
      OptiType = str_replace(str_replace(str_trim(
        str_sub(rawdat, 1, 21)), "    ", " "), "  ", " "),
      value = as.numeric(str_trim(str_sub(rawdat, 26, 34))),
      cycle = as.numeric(floor((row_number() - 1) / 4) + 1),
      thereshold = as.numeric(str_sub(rawdat, 39, 47))
    ) %>%
    dplyr::select(-rawdat)
  
  mF <- Glog$thereshold[1]
  rmsF <- Glog$thereshold[2]
  mD <- Glog$thereshold[3]
  rmsD <- Glog$thereshold[4]
  
  ggplot(data = Glog,
         mapping = aes(
           x = cycle,
           y = -log10(value),
           color = OptiType
         )) + geom_line() + geom_point(size = 0.5) +
    geom_hline(
      yintercept = -log10(mD),
      color = "#F8766D" ,
      linewidth = 0.8
    ) +
    geom_hline(
      yintercept = -log10(mF),
      color = "#00BA38",
      linewidth = 0.8
    ) +
    geom_hline(
      yintercept = -log10(rmsD),
      color = "#00BFC4",
      linewidth = 0.8
    ) +
    geom_hline(
      yintercept = -log10(rmsF),
      color = "#C77CFF",
      linewidth = 0.8
    ) +
    theme_minimal()
  
}