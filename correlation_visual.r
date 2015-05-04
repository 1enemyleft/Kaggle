# This script creates a class-wise feature importance heatmaps.

library(ggplot2)
library(gridExtra)
library(randomForest)

fname <- "feature_importance.png"


heatmapMatrix <- function(mat, xlab = "X", ylab = "Y", zlab = "Z", low = "white", high = "black",
                          grid = "grey", limits = NULL, legend.position = "top", colours = NULL){
  nr <- nrow(mat)
  nc <- ncol(mat)
  rnames <- rownames(mat)
  cnames <- colnames(mat)
  if(is.null(rnames)) rnames <- paste(xlab, 1:nr, sep = "_")
  if(is.null(cnames)) cnames <- paste(ylab, 1:nc, sep = "_")
  x <- rep(rnames, nc)
  y <- rep(cnames, each = nr)
  df <- data.frame(factor(x, levels = unique(x)),
                   factor(y, levels = unique(y)),
                   as.vector(mat))
  colnames(df) <- c(xlab, ylab, zlab)
  p <- ggplot(df, aes_string(ylab, xlab)) +
    geom_tile(aes_string(fill = zlab), colour = grid) +
      theme(legend.position=legend.position)
  if(is.null(colours)){
    p + scale_fill_gradient(low = low, high = high, limits = limits)
  }else{
    p + scale_fill_gradientn(colours = colours)
  }
}

# x: a vector of integer values
countFeature <- function(x){
  tbl <- table(x)
  idx <- as.integer(names(tbl))
  offset <- 1 - min(idx)
  vals <- rep(0, max(idx))
  vals[idx + offset] <- tbl
  vals[x + offset]
}

cat("Loading data\n")
training <- read.csv("../input/train.csv", row.names = 1)

cat("Data initialization\n\n")
X <- training[, -94]
y <- training$target
yMat <- model.matrix(~ target - 1, training)
colnames(yMat) <- 1:9

# Log1p
X2 <- log1p(X)

# Count feature
X.cf <- apply(X, 2, countFeature)

cat("Class-wise feature importance calculations\n")

cat("  Correlation\n")
linearCor <- abs(cor(X, yMat))

cat("  Correlation on log1p(X)\n")
loglinearCor <- abs(cor(X2, yMat))

cat("  Feature importance by randomForest\n")
model <- randomForest(X, y, ntree = 10, mtry = 10, importance = TRUE)
RfImp <- model$importance[,1:9]

cat("  Feature importance by randomForest on Count Features\n\n")
model <- randomForest(X.cf, y, ntree = 10, mtry = 10, importance = TRUE)
RfImp.CF <- model$importance[,1:9]


str93 <- formatC(1:93, width=2, flag=0)
rownames(RfImp.CF) <- rownames(RfImp) <- rownames(linearCor) <- rownames(loglinearCor) <- str93
colnames(RfImp) <- colnames(RfImp.CF) <- 1:9

p1 <- heatmapMatrix(linearCor, xlab = "X", ylab = "Class", zlab = "Corr", high = "blue")
p2 <- heatmapMatrix(loglinearCor, xlab = "log1p", ylab = "Class", zlab = "Corr_log1p", high = "blue",
                    limits = c(0, max(linearCor)))
p3 <- heatmapMatrix(RfImp, xlab = "X", ylab = "Class", zlab = "Imp_RF", high = "red")
p4 <- heatmapMatrix(RfImp.CF, xlab = "CountFeature", ylab = "Class", zlab = "Imp_RF_CF", high = "red")
#grid.arrange(p1, p2, p3, p4,, ncol = 4)
g <- arrangeGrob(p1, p2, p3, p4, ncol = 4)

cat("Saving 1920 x 1000 image \n")
ggsave(fname, g, dpi = 100, width = 19.2, height = 10, units="in")
