# wild bootstrap with recentering

# UNIT TESTED SUCCESSFULLY

wildBootstrap <- function(Z, matches) {
  
  # Split sample
  
  treatedSample <- Z[which(Z[,2] == 1),]
  controlSample <- Z[which(Z[,2] == 0),]
  
  n1 <- length(treatedSample[,1])
  n0 <- length(controlSample[,1])
  
  # Get residuals for each treatment unit
  
  tauHat <- getATE(Z)
  
  resids <- rep(0, times = n1)
  
  controlHat <- rep(0, times = n1)
  
  for(i in 1:n1) {
    # Find matched control unit(s) and construct estimated control outcome
    mates <- controlSample[which(matches[,i] == TRUE),]
    
    # Need to do something fiddly to have the correct number of dimensions for this
    if(length(mates) == 3) {
      controlHat[i] <- mean(mates[3])
    } else {
      controlHat[i] <- mean(mates[,3])
    }
    resids[i] <- treatedSample[i,3] - controlHat[i] - tauHat
    
  }
  
  # Center the residuals
  
  center <- mean(resids)
  centeredResids <- resids
  centeredResids <- resids - center
  
  # Construct perturbed outcomes
  
  bootTreatedSample <- treatedSample
  
  for(i in 1:n1) {
    # Flip a coin
    coin <- sample(c(0,1), 1)
    
    # If tails, flip the sign of resids[i]
    if(coin == 1) {
      perturb <- centeredResids[i]
    } else {
      perturb <- -centeredResids[i]
    }
    
    # Perturb outcome
    
    bootTreatedSample[i,3] <- controlHat[i] + tauHat + perturb
    
  }
  
  wildZ <- rbind(bootTreatedSample, controlSample) 
  
  return(wildZ)
  
  
}
