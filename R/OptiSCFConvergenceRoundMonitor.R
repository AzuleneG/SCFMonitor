OptiSCFConvergenceRoundMonitor <- function(directory) {
  ggplot(data = FormOptiSCFConvergenceRoundTibble(directory),
         mapping = aes(x = OptiRounds,
                       y = CR)) +
    geom_line() +
    geom_smooth() +
    theme_minimal()
}