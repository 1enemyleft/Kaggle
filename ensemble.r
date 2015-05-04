# Create a custom base learner library & specify the metalearner
h2o.gbm.1 <- function(..., ntrees = 43, 
                               max_depth = 9, 
                               min_rows = 9, 
                               learn_rate = 0.125, 
                               seed = 1) 
h2o.gbm.wrapper(..., ntrees = ntrees, 
                         max_depth = max_depth, 
                         min_rows = min_rows, 
                         learn_rate = learn_rate,
                         seed = seed)

h2o.deeplearning.1 <- function(..., hidden = c(120,120), 
                               activation = "Rectifier", 
                               epochs = 10.87304, 
                               seed = 1)  
h2o.deeplearning.wrapper(..., hidden = hidden, 
                         activation = activation, 
                         epochs = epochs,
                         seed = seed)

learner <- c("h2o.gbm.1", "h2o.deeplearning.1")
metalearner <- c("SL.glm")

fit <- h2o.ensemble(x=predictors,
                    y=response,
                    data=train_holdout.hex,
                    family = 'binomial',
                    learner = learner,
                    metalearner = metalearner)
