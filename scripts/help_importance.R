set.seed(71)
test.rf <- randomForest(io ~ hl + dist + emp_thousands.orig + emp_thousands.dest + 
                       + pop_density.orig + pop_density.dest, 
                     data = total[total$year==2000 | total$year==2001,],
                     mtry = 5, ntree = 1000,
                     importance = TRUE, keep.inbag = T)
varImpPlot(test.rf)
varImp(test.rf)
randomForest::importance(test.rf) # all the same

library(rfFC)
featureContributions(test.rf)
importance(fit.model.all[[1]])

li<-getLocalIncrements(test.rf, total[total$year==2000 | total$year==2001,c(6,7,9,11, 12, 14)])
#Calculate feature contributions
fc<-featureContributions(test.rf, li, total[total$year==2000 | total$year==2001,c(6,7,9,11, 12, 14)])

tc <- trainControl(method = "cv",
                   number = 10,
                   savePredictions = 'final',
                   allowParallel = TRUE)
tuneGrid <- expand.grid(.mtry = c(1: 6))


set.seed(71)
test.caret <- train(io ~ hl + dist + emp_thousands.orig + emp_thousands.dest + 
                     + pop_density.orig + pop_density.dest, 
                   data = total[total$year==2000 | total$year==2001,],
                   trControl = tc,     tuneGrid = tuneGrid, ntree = 2000,
                   method = "rf", importance = TRUE, keep.inbag = T)
varImp(test.caret)
randomForest::importance(test.caret$finalModel)
randomForest::importance(model.all2001$finalModel)

#cannot work, li 
featureContributions(test.caret$finalModel)
li<-getLocalIncrements(test.caret$finalModel, total[total$year==2000 | total$year==2001,c(6,7,9,11, 12, 14)])
#Calculate feature contributions
fc<-featureContributions(test.rf, li, total[total$year==2000 | total$year==2001,c(6,7,9,11, 12, 14)])





test.caret.noimp <- train(io ~ hl + dist + emp_thousands.orig + emp_thousands.dest + 
                      + pop_density.orig + pop_density.dest, 
                    data = total[total$year==2000 | total$year==2001,],
                    trControl = tc,
                    method = "rf")
varImp(test.caret.noimp, scale = T)



#
# CV
tc <- trainControl(method = "cv",
                   number = 10,
                   savePredictions = 'final')

# RF
# run the model for every 2 years
years <- 2000:2010

model.list <- list()
for (t in years){
  tplus1 <- t + 1
  set.seed(71)
  model.all.rf <- randomForest(io ~ hl + dist + emp_thousands.orig + emp_thousands.dest + 
                       + pop_density.orig + pop_density.dest, 
                     data = total[total$year==t | total$year==tplus1,],
                     trControl = tc, importance = TRUE)
  assign(paste0("model.all.rf",as.character(t + 1)), model.all.rf)
}

model.list <- list(model.all.rf2001, model.all.rf2002, model.all.rf2003,
                   model.all.rf2004, model.all.rf2005, model.all.rf2006,
                   model.all.rf2007, model.all.rf2008, model.all.rf2009, model.all.rf2010)

library(directlabels)

lapply(model.list, function(x) importance(x)) %>% 
  as.data.frame(.name_repair = "unique") %>% 
  dplyr::select(contains("IncMSE")) %>% 
  `colnames<-` (2001:2010) %>% 
  rownames_to_column(var = "features") %>% 
  pivot_longer(!features, names_to = "year", values_to = "importance") %>% 
  #pivot_wider(names_from = features, values_from = importance) %>%   
  #glimpse()
  ggplot(aes(x=year, y=importance, col=features, group=features)) + 
  geom_line(lwd=1) +
  geom_dl(aes(label = features), method = list(dl.combine("first.points", "last.points")), 
          cex = 0.8) +
  ylab("importance (%inc MSE)")

# CARET
model.list.caret <- list(model.all2001, model.all2002, model.all2003,
                   model.all2004, model.all2005, model.all2006,
                   model.all2007, model.all2008, model.all2009, model.all2010)

library(directlabels)

lapply(model.list.caret, function(x) importance(x$finalModel)) %>% 
  as.data.frame(.name_repair = "unique") %>% 
  dplyr::select(contains("IncMSE")) %>% 
  `colnames<-` (2001:2010) %>% 
  rownames_to_column(var = "features") %>% 
  pivot_longer(!features, names_to = "year", values_to = "importance") %>% 
  #pivot_wider(names_from = features, values_from = importance) %>%   
  #glimpse()
  ggplot(aes(x=year, y=importance, col=features, group=features)) + 
  geom_line(lwd=1) +
  geom_dl(aes(label = features), method = list(dl.combine("first.points", "last.points")), 
          cex = 0.8) +
  ylab("importance (%inc MSE)")


varImp(model.all.rf2001, scale = T)
varImp(model.all2001, scale = F)

importance(model.all.rf2003)
importance(model.all2001$finalModel)
i<-as.data.frame(importance(model.all.rf2001))

years_ <- 2001:2010
n <- NULL
model <- NULL
for (t in years_){
  name = paste0("model.all.rf", t)
  assign(name, model) 
  i = as.data.frame(importance(mode))
  n = cbind(n, i)
}

l <- list(model.all.rf2002, model.all.rf2003)
lapply(l, function(x) importance(x))



# I tries .mtry as a way to select variables and the oos results are inferior.
# # CV
# tc <- trainControl(method = "cv",
#                    number = 10,
#                    savePredictions = 'final',
#                    allowParallel = TRUE)
# tuneGrid <- expand.grid(.mtry = c(1: 6))
