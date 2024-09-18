#' Read and Plot SCF Convergence Process for Multiple Round of Optimization
#'
#' This function reads a log file automatically and shows the SCF convergence process of it by generating line plots
#' @param directory A string vector describing the directory of the Gaussian log file.
#' @param top_rounds A numeric vector deciding which SCF convergence process will be shown in the diagram. etc. input 5 for the newest 5 rounds of optimization. Enter -1 for showing all the processes.
#' @returns No return value, called for side effects
#' @export
#' @examples
#'
#' MultipleRoundOptiSCFIntegratedMonitor(SCFMonitorExample(), -1)
#' MultipleRoundOptiSCFIntegratedMonitor(SCFMonitorExample(), 5)
#'
#' @name MultipleRoundOptiSCFIntegratedMonitor

utils::globalVariables(names = c("SCFConver", "BOT", "TOP"), package = "SCFMonitor")

MultipleRoundOptiSCFIntegratedMonitor <-
  function(directory, top_rounds = -1) {
    if (top_rounds == -1) {
      read_dat <- OptiSCFMonitorAsWholeTibble(directory)
      MultipleRoundOptiSCFplotting(read_dat[[1]],
        SCFconver = -log10(read_dat[[2]]),
        BOT = min(read_dat[[1]]$OptiCycle),
        TOP = max(read_dat[[1]]$OptiCycle)
      )
    } else if (top_rounds > 0) {
      read_dat <- OptiSCFMonitorAsWholeTibble(directory)
      MultipleRoundOptiSCFplotting(read_dat[[1]],
        SCFconver = -log10(read_dat[[2]]),
        BOT = ifelse(
          max(read_dat[[1]]$OptiCycle) - top_rounds >= 1,
          yes = max(read_dat[[1]]$OptiCycle) - top_rounds + 1,
          no = 1
        ),
        TOP = max(read_dat[[1]]$OptiCycle)
      )
    } else {
      return("ERROR: wrong number of top rounds input. Use -1 for outputing all SCF diagrams and positive integers for the number of latest rounds whom you want to show in the diagram.")
    }
  }
