##building visual of roc_auc curve to compare models between GBM and ANN 

pred_gbm <- predict(gbm.model, validation) 
pred_gbm_pref <- h2o.performance(gbm.model, validation, class = "F1") 

pred_ann <- predict(ann.model, validation) 
pred_ann_pref <- h2o.performance(ann.model, validation, class = "F1") 

plot(pred_gbm_pref,  type = "roc", col = "blue", typ = "b") 
plot(pred_ann_pref,  type = "roc", col = "blue", typ = "b") 
