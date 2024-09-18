#' Form a Tibble of SCF data for each Optimization Steps
#'
#' This function outputs a tibble containing the data of each rounds of SCF calculation labeled with the optimization round it's in (if it's a optimization job, otherwise it will be only 1)
#' @param directory A string vector describing the directory of the Gaussian log file.
#' @returns A list containing two elements. The first one is a tibble containing the SCF data of every rounds labeled with the optimization steps they are in. The second element is a numeric vector that refers to the SCF convergence standard.
#' @importFrom readr read_file
#' @importFrom stringr str_split str_detect str_extract str_replace str_trim
#' @importFrom utils head
#' @importFrom tidyselect starts_with
#' @importFrom dplyr rename filter mutate row_number select add_row  ungroup rowwise
#' @importFrom tibble as_tibble
#' @export
#' @examples
#' library(readr)
#' library(stringr)
#' library(tidyselect)
#' library(utils)
#' library(dplyr)
#' library(tibble)
#'
#' OptiSCFMonitorAsWholeTibble(SCFMonitorExample())
#'
#' @name OptiSCFMonitorAsWholeTibble

utils::globalVariables(names = c("OptiCycle"), package = "SCFMonitor")

OptiSCFMonitorAsWholeTibble <- function(directory) {
  Glog <- read_file(directory) %>%
    stringr::str_split("\n") %>%
    as.data.frame() %>%
    tibble::as_tibble() %>%
    dplyr::rename(rawdat = tidyselect::starts_with("c"))

  ConverStandard <- utils::head(filter(Glog, stringr::str_detect(rawdat, "Requested convergence on RMS density matrix=")), n = 1L) %>%
    dplyr::mutate(rawdat = stringr::str_extract(rawdat, "matrix=\\d\\.\\d\\d..\\d\\d")) %>%
    dplyr::mutate(rawdat = as.numeric(stringr::str_replace(stringr::str_trim(stringr::str_extract(rawdat, "\\d\\.\\d\\d..\\d\\d")), "D", "E")))

  Glog <- Glog %>%
    filter(stringr::str_detect(rawdat, "RMSDP=") |
      stringr::str_detect(rawdat, " Cycle   1  ")) %>%
    dplyr::mutate(rowid = dplyr::row_number()) %>%
    dplyr::mutate(rawdat = stringr::str_trim(rawdat))

  index <- filter(Glog, stringr::str_detect(rawdat, "^Cycle")) %>%
    dplyr::select(rowid) %>%
    tibble::add_row(rowid = nrow(Glog))

  Glog <- Glog %>%
    dplyr::mutate(
      RMSDP = stringr::str_extract(rawdat, "RMSDP=\\d\\.\\d\\d..\\d\\d"),
      MaxDP = stringr::str_extract(rawdat, "MaxDP=\\d\\.\\d\\d..\\d\\d"),
      DE = stringr::str_extract(rawdat, "DE=.\\d\\.\\d\\d..\\d\\d"),
      OVMax = stringr::str_extract(rawdat, "OVMax=.\\d\\.\\d\\d..\\d\\d")
    ) %>%
    dplyr::mutate(
      RMSDP = stringr::str_trim(stringr::str_extract(RMSDP, "\\d\\.\\d\\d..\\d\\d")),
      MaxDP = stringr::str_trim(stringr::str_extract(MaxDP, "\\d\\.\\d\\d..\\d\\d")),
      DE = stringr::str_trim(stringr::str_extract(DE, ".\\d\\.\\d\\d..\\d\\d")),
      OVMax = stringr::str_trim(stringr::str_extract(OVMax, ".\\d\\.\\d\\d..\\d\\d"))
    ) %>%
    dplyr::select(-rawdat) %>%
    dplyr::rowwise() %>%
    dplyr::mutate(OptiCycle = DirectingOptiRounds(rowid, index)) %>%
    dplyr::mutate(Cycle = rowid - index$rowid[[OptiCycle]]) %>%
    dplyr::ungroup() %>%
    dplyr::filter(!is.na(RMSDP)) %>%
    dplyr::select(-rowid)

  return(list(Glog, ConverStandard$rawdat[[1]]))
}
