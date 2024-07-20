MultipleRoundOptiSCFplotting <- function(SCFData, SCFconver, BOT, TOP) {
  SCFData <- SCFData %>%
    pivot_longer(!c(Cycle, OptiCycle),
                 names_to = "SCFdatType",
                 values_to = "valueT") %>%
    mutate(value = as.numeric(str_replace(valueT, "D", "E"))) %>%
    filter((OptiCycle>=BOT) & (OptiCycle<=TOP))
  
  ggplot(data = SCFData,
         mapping = aes(
           x = Cycle,
           y = -log10(abs(value)),
           color = SCFdatType
         )) + geom_line() +
    geom_hline(
      yintercept = SCFconver - 2 + 0.03,
      color = "#F8766D",
      linewidth = 1.05
    ) +
    geom_hline(yintercept = SCFconver - 2 , color = "#00BA38") +
    geom_hline(yintercept = SCFconver , color = "#C77CFF") +
    theme_minimal() +
    facet_wrap( ~ OptiCycle)
}