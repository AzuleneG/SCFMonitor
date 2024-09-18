#' Directing Optimization Round of a SCF Convergence Round in the Tibble Formed in OptiSCFMonitorAsWholeTibble()
#'
#' This function is a internal function that directs the optimization round of a SCF convergence round. This helps SCFMonitor devide the SCF rounds to different sections that each refers to an optimization cycle.
#' @param Pending A integer refering to the row of the directed SCF convergence cycle is in.
#' @param index A tibble including all the row number
#' @returns A integer directing the Optimization round of that SCF convergence round is in.
#' @export
#' @examples
#' library(tibble)
#'
#' example_index <- tibble(rowid = c(1, 30, 130))
#' DirectingOptiRounds(33, example_index)
#'
#' @name DirectingOptiRounds

DirectingOptiRounds <- function(Pending, index) {
  for (i in 1:(nrow(index) - 1)) {
    if ((index$rowid[[i]] <= Pending) &
      (index$rowid[[i + 1]] >= Pending)) {
      return(i)
    }
  }
}
