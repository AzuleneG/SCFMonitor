MultipleRoundOptiSCFIntegratedMonitor <-
  function(directory , top_rounds=-1) {
    if(top_rounds == -1){
      read_dat = OptiSCFMonitorAsWholeTibble(directory)
      MultipleRoundOptiSCFplotting(read_dat[[1]], SCFconver = -log10(read_dat[[2]]) , 
                                   BOT = min(read_dat[[1]]$OptiCycle) , 
                                   TOP = max(read_dat[[1]]$OptiCycle))
    }else if(top_rounds > 0){
      read_dat = OptiSCFMonitorAsWholeTibble(directory)
      MultipleRoundOptiSCFplotting(read_dat[[1]], SCFconver = -log10(read_dat[[2]]) , 
                                   BOT = ifelse(
                                     max(read_dat[[1]]$OptiCycle)-top_rounds >= 1,
                                     yes = max(read_dat[[1]]$OptiCycle)-top_rounds+1,
                                     no = 1),
                                   TOP = max(read_dat[[1]]$OptiCycle))
    }else{
      return("ERROR: wrong number of top rounds input. Use -1 for outputing all SCF diagrams and positive integers for the number of latest rounds whom you want to show in the diagram.")
    }
  }