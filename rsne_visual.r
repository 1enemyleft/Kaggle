###### install Rtsne latest version
library(devtools)
install_github("Rtsne","jkrijthe")
######

library(Rtsne)
#setwd("train")
train <- read.csv("train.csv", stringsAsFactors=FALSE)[, -1]

set.seed(1234)
tsne_out_train <- Rtsne(as.matrix(train[,1:93]), check_duplicates = FALSE, pca = TRUE, perplexity=30, theta=0.5, dims=2)

my_palette = c("red", "blue", "green", "brown", "magenta", "orange", "cyan", "black", "yellow")
palette(my_palette)

plot(tsne_out_train$Y, xlab="", ylab="", col=as.factor(train$target), pch=".", cex=4, axes=FALSE)

legend("bottomleft", c("1","2", "3", "4", "5", "6", "7", "8", "9"),  
       lty=c(1,1), lwd=c(5,5), col=my_palette, bty="n", cex = 0.7) 

palette("default")
