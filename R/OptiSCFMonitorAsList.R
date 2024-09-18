#' Form a list Containing SCF Data of Each Optimization Cycles
#'
#' This function reads a Gaussian .log file and outputs a list of tibbles, each of which is the SCF Data of a optimization step.
#' @param directory A string vector describing the directory of the Gaussian log file.
#' @returns A list of lists. First lists is a list of tibble, each element in the list refers to a tibble recording the SCF Data of a optimization step. The second list only have one element that is a numeric vector refering to the SCF convergence requirement read from log file.
#' @importFrom readr read_file
#' @importFrom stringr str_split str_detect str_trim str_replace str_extract
#' @importFrom tidyselect starts_with
#' @importFrom utils head
#' @importFrom dplyr rename filter mutate row_number select add_row
#' @importFrom tibble as_tibble rowid_to_column
#' @export
#' @examples
#' library(readr)
#' library(stringr)
#' library(tidyselect)
#' library(utils)
#' library(dplyr)
#' library(tibble)
#'
#' OptiSCFMonitorAsList(SCFMonitorExample())
#'
#' @name OptiSCFMonitorAsList

utils::globalVariables(names = c("rawdat", "rowid", "RMSDP", "MaxDP", "DE", "OVMax"), package = "SCFMonitor")

OptiSCFMonitorAsList <- function(directory) {
  Glog <- readr::read_file(directory) %>%
    stringr::str_split("\n") %>%
    as.data.frame() %>%
    tibble::as_tibble() %>%
    dplyr::rename(rawdat = dplyr::starts_with("c"))

  ConverStandard <- utils::head(dplyr::filter(Glog, stringr::str_detect(rawdat, "Requested convergence on RMS density matrix=")), n = 1L) %>%
    dplyr::mutate(rawdat = stringr::str_extract(rawdat, "matrix=\\d\\.\\d\\d..\\d\\d")) %>%
    dplyr::mutate(rawdat = as.numeric(stringr::str_replace(stringr::str_trim(stringr::str_extract(rawdat, "\\d\\.\\d\\d..\\d\\d")), "D", "E")))

  Glog <- Glog %>%
    dplyr::filter(stringr::str_detect(rawdat, "RMSDP=") |
      stringr::str_detect(rawdat, " Cycle   1  ")) %>%
    dplyr::mutate(rowid = row_number()) %>%
    dplyr::mutate(rawdat = stringr::str_trim(rawdat))

  index <- dplyr::filter(Glog, stringr::str_detect(rawdat, "^Cycle")) %>%
    dplyr::select(rowid) %>%
    dplyr::add_row(rowid = nrow(Glog))

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
    dplyr::select(-rawdat)

  SCFtibs <- Glog %>%
    dplyr::filter((rowid > index$rowid[1]) & (rowid < index$rowid[2])) %>%
    dplyr::select(-rowid) %>%
    list()

  for (i in 2:nrow(index) - 1) {
    temp <-
      dplyr::filter(Glog, (rowid > index$rowid[i]) &
        (rowid < index$rowid[i + 1])) %>%
      dplyr::select(-rowid)

    SCFtibs[i] <- list(temp)
  }

  row_cyclize <- function(x) {
    tibble::rowid_to_column(x, var = "cycle")
  }

  SCFlist <- lapply(SCFtibs, row_cyclize)

  return(list(SCFlist, ConverStandard$rawdat[[1]]))
}
