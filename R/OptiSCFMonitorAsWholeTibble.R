OptiSCFMonitorAsList <- function(directory) {
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
    dplyr::select(-rawdat)
  
  SCFtibs <- Glog %>%
    filter((rowid > index$rowid[1]) & (rowid < index$rowid[2])) %>%
    dplyr::select(-rowid) %>%
    list()
  
  for (i in 2:nrow(index) - 1) {
    temp <-
      filter(Glog, (rowid > index$rowid[i]) &
               (rowid < index$rowid[i + 1])) %>%
      dplyr::select(-rowid)
    
    SCFtibs[i] <- list(temp)
  }
  
  row_cyclize <- function(x) {
    rowid_to_column(x, var = "cycle")
  }
  
  SCFlist<- lapply(SCFtibs, row_cyclize)
  
  return(list(SCFlist,ConverStandard$rawdat[[1]]))
}