# Ratio Metric Data
ratio.data <- copy(turtle.data)
corrections <- c('first test of 60K',
                 'second test of 60K',
                 '10K/Hist',
                 'Hist Post Wash')

ratio1 <- ratio.data[, c(1:7, 11)][ , zone:=1] %>%
   rename(diameter = z1,
          pct.zero.ca = pct.zero.ca.z1,
          pct.delta.prior = pct.delta.prior.z1)

ratio2 <- ratio.data[, c(1:4, 8:11)][ , zone:=2] %>%
   rename(diameter = z2,
          pct.zero.ca = pct.zero.ca.z2,
          pct.delta.prior=pct.delta.prior.z2)

ratio.data <- rbind(ratio1, ratio2)
ratio.data[ , correction:= +(measure %in% corrections)] %>%
   .[measure == '10K' & chem == 'hist' , correction:= 1]

# Add random water and chemical mapping
set.seed(27)
water.cont <- c()
for (n in 1:nrow(ratio.data)) {
   if(ratio.data[n, water] == "21CN"){
      x <- runif(1, min = 1, max = 2)
      water.cont <- c(water.cont, x)
   }else if(ratio.data[n, water] == "21CA"){
      x <- runif(1, min = 2, max = 3)
      water.cont <- c(water.cont, x)
   }else if(ratio.data[n, water] == "5CN"){
      x <- runif(1, min = 3, max = 4)
      water.cont <- c(water.cont, x)
   }else if(ratio.data[n, water] == "5CA"){
      x <- runif(1, min = 4, max = 5)
      water.cont <- c(water.cont, x)
   }else{ next }
}

# chem
chem.cont <- c()
for (n in 1:nrow(ratio.data)) {
   if(ratio.data[n, chem] == "acetyl"){
      x <- runif(1, min = 1, max = 2)
      chem.cont <- c(chem.cont, x)
   }else if(ratio.data[n, chem] == "fiveht"){
      x <- runif(1, min = 2, max = 3)
      chem.cont <- c(chem.cont, x)
   }else if(ratio.data[n, chem] == "fourap"){
      x <- runif(1, min = 3, max = 4)
      chem.cont <- c(chem.cont, x)
   }else if(ratio.data[n, chem] == "glyb"){
      x <- runif(1, min = 4, max = 5)
      chem.cont <- c(chem.cont, x)
   }else if(ratio.data[n, chem] == "hist"){
      x <- runif(1, min = 5, max = 6)
      chem.cont <- c(chem.cont, x)
   }else{ next }
}

ratio.data <- cbind(ratio.data, water.cont, chem.cont)

# remove unneeded variables
rm(ratio1, ratio2,
   water.cont, chem.cont,
   n, x)
return(ratio.data)