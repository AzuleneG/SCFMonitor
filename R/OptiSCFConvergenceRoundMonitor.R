#' Read and Plot the Counts the SCF Convergence Rounds of Each Optimization Step of a Gaussian Log File.
#'
#' This function reads a log file automatically and generate a plot showing the steps it takes to reach SCF convergence for each optimization process.
#' @param directory A string vector describing the directory of the Gaussian log file.
#' @returns No return value, called for side effects
#' @importFrom ggplot2 ggplot aes geom_line geom_smooth theme_minimal
#' @export
#' @examples
#' library(ggplot2)
#'
#' OptiSCFConvergenceRoundMonitor(SCFMonitorExample())
#'
#' @name OptiSCFConvergenceRoundMonitor

utils::globalVariables(names = c("OptiRounds", "CR"), package = "SCFMonitor")

OptiSCFConvergenceRoundMonitor <- function(directory) {
  ggplot(
    data = FormOptiSCFConvergenceRoundTibble(directory),
    mapping = ggplot2::aes(
      x = OptiRounds,
      y = CR
    )
  ) +
    geom_line() +
    geom_smooth() +
    theme_minimal()
}
