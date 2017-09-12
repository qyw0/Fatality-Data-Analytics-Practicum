#
#========Need to change file path to your local directory==========
# 
#======================Data Cleaning Part==========================
#

library(dplyr)
library(reshape2)
library(sqldf)

#subset record 1-20 from source files. Below result will be used in FP Growth
mort<- read.csv('C:/Users/qwang/Desktop/mort/mort2013.csv',header=TRUE)
New.mort <- mort[90:109]
write.csv(New.mort,file="C:/Users/qwang/Desktop/mort/rac2012.csv", na = "",row.names = FALSE)

#After running FP growth on Spark & AWS
#Read FP growth result file(txt) and split string in to multiple columns

result <- read.table('C:/Users/qwang/Desktop/mort/10-year-results.txt',header=TRUE,sep="\t")
items <- colsplit(result$items,', ', c('code1','code2','code3','code4','code5'))
re <- cbind(items,result)

#Clean format
re$`code1` <- gsub("[[u]","",as.factor(re$`code1`))
re$`code1` <- gsub("[]]","",as.factor(re$`code1`))
re$`code2` <- gsub("[]]","",as.factor(re$`code2`))
re$`code3` <- gsub("[]]","",as.factor(re$`code3`))
re$`code4` <- gsub("[]]","",as.factor(re$`code4`))
re$`code5` <- gsub("[]]","",as.factor(re$`code5`))

re$`code3` <- gsub("^.","",as.factor(re$`code3`))
re$`code2` <- gsub("^.","",as.factor(re$`code2`))
re$`code4` <- gsub("^.","",as.factor(re$`code4`))
re$`code5` <- gsub("^.","",as.factor(re$`code5`))

re$`items` <- gsub("u","",as.factor(re$`items`))

write.csv(re,file = "C:/Users/qwang/Desktop/result")# this will be used in following steps

#Read ucr39 description file

ucr39.dict <- read.csv('C:/Users/qwang/Desktop/ucr39.desc.csv',header=TRUE)
test <- sqldf::sqldf("select distinct code1,ucr39,ucod,freq 
                    from re left join 'icd.m.uniq' on ucod=code1")

#create ucod to ucr look-up
icd.match <- read.csv('C:/Users/qwang/Desktop/mort2015.csv',header=TRUE)
icd.m <- icd.match[c('ucod', "ucr358","ucr113","ucr130","ucr39")]
icd.m.uniq <- unique(icd.m)

  #repeat below codes using different years' data
mort<- read.csv('C:/Users/qwang/Desktop/mort/mort2005.csv',header=TRUE)
icd12 <- mort[c('ucod', "ucr358","ucr113","ucr130","ucr39")]
icd12.u <-unique(icd12)
test <- rbind(icd12.u,test1)
test1 <- unique(test)
test2 <- merge(test1,ucr39.dict, by='ucr39')
test2 <- test2[c(2,3,4,5,1,6)] #final file to csv, [ucod, ucr358/113/130/39/desc]

test3 <- test2[,c(1,6)] 
test3 <- unique(test3) #icd desc, [ucod, desc]







