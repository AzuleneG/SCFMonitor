#' Read and Plot the Optimization Process of a Gaussian Log File.
#'
#' This function reads a log file automatically and shows the optimization convergence process of it by generating line plots
#' @param directory A string vector describing the directory of the Gaussian log file.
#' @returns No return value, called for side effects
#' @importFrom readr read_file
#' @importFrom stringr str_split str_detect str_trim str_replace str_sub
#' @importFrom tidyselect starts_with
#' @importFrom dplyr rename filter mutate row_number select
#' @importFrom tibble as_tibble
#' @importFrom ggplot2 ggplot aes geom_line geom_point geom_hline theme_minimal
#' @export
#' @examples
#' library(readr)
#' library(stringr)
#' library(tidyselect)
#' library(dplyr)
#' library(tibble)
#' library(ggplot2)
#'
#' OptiConvergenceMonitor(SCFMonitorExample())
#'
#' @name OptiConvergenceMonitor

utils::globalVariables(names = c("rawdat", "cycle", "value", "OptiType"), package = "SCFMonitor")

OptiConvergenceMonitor <- function(directory) {
  Glog <- readr::read_file(directory) %>%
    stringr::str_split("\n") %>%
    as.data.frame() %>%
    tibble::as_tibble() %>%
    dplyr::rename(rawdat = tidyselect::starts_with("c")) %>%
    dplyr::filter(
      stringr::str_detect(rawdat, "^ Maximum Displacement") |
        stringr::str_detect(rawdat, "^ Maximum Force") |
        stringr::str_detect(rawdat, "^ RMS     Force") |
        stringr::str_detect(rawdat, "^ RMS     Displacement")
    ) %>%
    dplyr::mutate(rawdat = stringr::str_trim(rawdat))

  Glog <- Glog %>%
    dplyr::mutate(
      OptiType = stringr::str_replace(stringr::str_replace(stringr::str_trim(
        stringr::str_sub(rawdat, 1, 21)
      ), "    ", " "), "  ", " "),
      value = as.numeric(stringr::str_trim(stringr::str_sub(rawdat, 26, 34))),
      cycle = as.numeric(floor((dplyr::row_number() - 1) / 4) + 1),
      thereshold = as.numeric(stringr::str_sub(rawdat, 39, 47))
    ) %>%
    dplyr::select(-rawdat)

  mF <- Glog$thereshold[1]
  rmsF <- Glog$thereshold[2]
  mD <- Glog$thereshold[3]
  rmsD <- Glog$thereshold[4]

  ggplot2::ggplot(
    data = Glog,
    mapping = ggplot2::aes(
      x = cycle,
      y = -log10(value),
      color = OptiType
    )
  ) +
    ggplot2::geom_line() +
    ggplot2::geom_point(size = 0.5) +
    ggplot2::geom_hline(
      yintercept = -log10(mD),
      color = "#F8766D",
      linewidth = 0.8
    ) +
    ggplot2::geom_hline(
      yintercept = -log10(mF),
      color = "#00BA38",
      linewidth = 0.8
    ) +
    ggplot2::geom_hline(
      yintercept = -log10(rmsD),
      color = "#00BFC4",
      linewidth = 0.8
    ) +
    ggplot2::geom_hline(
      yintercept = -log10(rmsF),
      color = "#C77CFF",
      linewidth = 0.8
    ) +
    ggplot2::theme_minimal()
}
