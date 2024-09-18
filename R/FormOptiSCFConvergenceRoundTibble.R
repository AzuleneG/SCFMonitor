#' Form a Tibble of Total SCF Rounds in the Optimization Cycles
#'
#' This function outputs a tibble showing each the number of SCF rounds applied in each optimization cycle and outputs it as a tibble.
#' @param directory A string vector describing the directory of the Gaussian log file.
#' @returns A tibble countain two columns, describing each optimization rounds and the number of SCF rounds it undergoes until convergence.
#' @importFrom readr read_file
#' @importFrom stringr str_split str_detect str_trim
#' @importFrom tidyselect starts_with
#' @importFrom dplyr rename filter mutate row_number select add_row lead
#' @importFrom tibble as_tibble
#' @export
#' @examples
#' library(readr)
#' library(stringr)
#' library(tidyselect)
#' library(dplyr)
#' library(tibble)
#'
#' FormOptiSCFConvergenceRoundTibble(SCFMonitorExample())
#'
#' @name FormOptiSCFConvergenceRoundTibble

utils::globalVariables(names = c("CR", "rawdat", "OptiRounds"), package = "SCFMonitor")

FormOptiSCFConvergenceRoundTibble <- function(directory) {
  Glog <- readr::read_file(directory) %>%
    stringr::str_split("\n") %>%
    as.data.frame() %>%
    tibble::as_tibble() %>%
    dplyr::rename(rawdat = tidyselect::starts_with("c")) %>%
    dplyr::filter(stringr::str_detect(rawdat, "RMSDP=") |
      stringr::str_detect(rawdat, " Cycle   1  ")) %>%
    dplyr::mutate(CR = dplyr::row_number()) %>%
    dplyr::mutate(rawdat = stringr::str_trim(rawdat))

  filter(Glog, stringr::str_detect(rawdat, "^Cycle")) %>%
    dplyr::select(CR) %>%
    dplyr::add_row(CR = nrow(Glog)) %>%
    dplyr::mutate(OptiRounds = dplyr::row_number()) %>%
    dplyr::mutate(CR = dplyr::lead(CR) - CR - 1)
}
