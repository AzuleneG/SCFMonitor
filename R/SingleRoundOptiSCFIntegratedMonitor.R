#' Read and Plot SCF Convergence Process for a Single Round of Optimization
#'
#' This function reads a log file automatically and shows the SCF convergence process of a single round of optimization by generating line plots
#' @param directory A string vector describing the directory of the Gaussian log file.
#' @param optiround A numeric vector deciding which SCF convergence process will be shown in the diagram. etc. input 5 for the 5th round of optimization. If it's not an optimization job than enter 1 for acquiring the only one.
#' @returns No return value, called for side effects
#' @export
#' @examples
#'
#' SingleRoundOptiSCFIntegratedMonitor(SCFMonitorExample(), 5)
#'
#' @name SingleRoundOptiSCFIntegratedMonitor

SingleRoundOptiSCFIntegratedMonitor <- function(directory, optiround) {
  read_dat <- OptiSCFMonitorAsList(directory)
  SingleSCFplotting(read_dat[[1]][[optiround]], SCFconver = -log10(read_dat[[2]]))
}
