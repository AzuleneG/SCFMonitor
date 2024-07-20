OptiSCFMonitorAsWholeTibble <- function(directory) {
  Glog <- read_file(directory) %>%
    str_split("\n") %>%
    as.data.frame() %>%
    as_tibble() %>%
    rename(rawdat = starts_with("c"))
  
  ConverStandard <- head(filter(Glog, str_detect(rawdat,"Requested convergence on RMS density matrix=")), n=1L) %>%
    mutate(rawdat = str_extract(rawdat, "matrix=\\d\\.\\d\\d..\\d\\d")) %>%
    mutate(rawdat = as.numeric(str_replace(str_trim(str_extract(rawdat, "\\d\\.\\d\\d..\\d\\d")), "D", "E")))
    
  Glog <- Glog %>%
    filter(str_detect(rawdat, "RMSDP=") |
             str_detect(rawdat, " Cycle   1  ")) %>%
    mutate(rowid = row_number()) %>%
    mutate(rawdat = str_trim(rawdat))
  
  index <- filter(Glog, str_detect(rawdat , "^Cycle")) %>%
    dplyr::select(rowid) %>%
    add_row(rowid = nrow(Glog))
  
  Glog <- Glog %>%
    mutate(
      RMSDP = str_extract(rawdat, "RMSDP=\\d\\.\\d\\d..\\d\\d"),
      MaxDP = str_extract(rawdat, "MaxDP=\\d\\.\\d\\d..\\d\\d"),
      DE = str_extract(rawdat, "DE=.\\d\\.\\d\\d..\\d\\d"),
      OVMax = str_extract(rawdat, "OVMax=.\\d\\.\\d\\d..\\d\\d")
    ) %>%
    mutate(
      RMSDP = str_trim(str_extract(RMSDP, "\\d\\.\\d\\d..\\d\\d")),
      MaxDP = str_trim(str_extract(MaxDP, "\\d\\.\\d\\d..\\d\\d")),
      DE = str_trim(str_extract(DE, ".\\d\\.\\d\\d..\\d\\d")),
      OVMax = str_trim(str_extract(OVMax, ".\\d\\.\\d\\d..\\d\\d"))
    ) %>%
    dplyr::select(-rawdat) %>%
    rowwise() %>%
    mutate(OptiCycle = DirectingOptiRounds(rowid, index)) %>%
    mutate(Cycle = rowid - index$rowid[[OptiCycle]]) %>%
    ungroup() %>%
    filter(!is.na(RMSDP)) %>%
    select(-rowid)
  
  return(list(Glog,ConverStandard$rawdat[[1]]))
}