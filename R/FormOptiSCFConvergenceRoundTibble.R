FormOptiSCFConvergenceRoundTibble <- function(directory) {
  Glog <- read_file(directory) %>%
    str_split("\n") %>%
    as.data.frame() %>%
    as_tibble() %>%
    rename(rawdat = starts_with("c")) %>%
    filter(str_detect(rawdat, "RMSDP=") |
             str_detect(rawdat, " Cycle   1  ")) %>%
    mutate(CR = row_number()) %>%
    mutate(rawdat = str_trim(rawdat))
  
  filter(Glog, str_detect(rawdat , "^Cycle")) %>%
    dplyr::select(CR) %>%
    add_row(CR = nrow(Glog)) %>%
    mutate(OptiRounds = row_number()) %>%
    mutate(CR = lead(CR) - CR - 1)
}