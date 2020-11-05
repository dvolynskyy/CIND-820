projectData = read.csv("D:\\Study\\CIND820 - Big Data Analytics Project\\Project\\Initial Analysis\\credit_card.csv", header = TRUE,  sep = ",", stringsAsFactors = FALSE)

library(ggplot2)
head(projectData)

colnames(projectData)[colnames(projectData)=="default.payment.next.month"] <- "DEFAULT_PAYMENT"
head(projectData)

dim(projectData)

str(projectData)

projectData[, 1:25] <- sapply(projectData[, 1:25], as.numeric)
str(projectData)

#install.packages("mlbench")

library(mlbench)

# distribution of class variable
y <- projectData$DEFAULT_PAYMENT
cbind(freq=table(y), percentage=prop.table(table(y))*100)

summary(projectData)


library(DataExplorer)
library(dplyr)

projectData %>% count(EDUCATION, sort = FALSE)
projectData %>% count(MARRIAGE, sort = FALSE)

projectData$EDUCATION[projectData$EDUCATION == 0] <- 4
projectData$EDUCATION[projectData$EDUCATION == 5] <- 4
projectData$EDUCATION[projectData$EDUCATION == 6] <- 4

projectData$MARRIAGE[projectData$MARRIAGE == 0] <- 3

projectData %>% count(EDUCATION, sort = FALSE)
projectData %>% count(MARRIAGE, sort = FALSE)



correlations <- cor(projectData[,2:25])
print(correlations)


plot_correlation(na.omit(projectData), maxcat = 5L)

plot_histogram(projectData)



modelData <- select(projectData, !c('ID', 'BILL_AMT1','BILL_AMT2', 'BILL_AMT3','BILL_AMT4','BILL_AMT5','BILL_AMT6'))

plot_correlation(na.omit(modelData), maxcat = 5L)

#install.packages('imbalance')
library(imbalance)

newSamples <- mwmote(modelData, numInstances = 10000, classAttr = "DEFAULT_PAYMENT")
summary(newSamples)

newData<-rbind(modelData, newSamples)

set.seed(7)
rows <- sample(nrow(newData))
newDataShuffled <- newData[rows, ]

plot_correlation(na.omit(newDataShuffled), maxcat = 5L)

z <- newData$DEFAULT_PAYMENT
cbind(freq=table(z), percentage=prop.table(table(z))*100)
