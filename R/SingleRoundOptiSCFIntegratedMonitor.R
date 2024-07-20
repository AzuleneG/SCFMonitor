SingleRoundOptiSCFIntegratedMonitor <-
  function(directory, optiround) {
    read_dat = OptiSCFMonitorAsList(directory)
    SingleSCFplotting(read_dat[[1]][[optiround]] , SCFconver = -log10(read_dat[[2]]))
  }