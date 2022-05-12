install.packages("dplyr")
install.packages("tidyverse")
install.packages("magrittr")
install.packages("pipeR")


rnorm(200) %>>%
  matrix(ncol = 2) %T>>%
  plot %>>% 
  colSums