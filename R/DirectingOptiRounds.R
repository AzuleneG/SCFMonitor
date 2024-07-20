DirectingOptiRounds <- function(Pending, index) {
  for (i in 1:(nrow(index) - 1)) {
    if ((index$rowid[[i]] <= Pending) &
        (index$rowid[[i + 1]] >= Pending)) {
      return(i)
    }
  }
}