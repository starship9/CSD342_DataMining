
x=subset(iris,Petal.Width<=0.4)
x2=read.table("C:/Users/MOHAK GARG/Desktop/Sem 6/Data Mining/nglaData.txt",header=FALSE)
set1=subset(x2,V3>7.5)
per1={nrow(set1)/nrow(x2)}*100
per2={nrow(subset(x2,V3>7.5&V3<8.5))/nrow(x2)}*100
set2=subset(x2,V2==6)
avg=mean(set2$V3)
class(set2)
head(set2,100)

library(dplyr)
randRows<-sample_n(set2,6)
head(randRows)
class(randRows)
rowVector<-unlist(randRows$V1)
as.vector(rowVector)
class(rowVector)
set2New<-mutate(set2,ifelse(set2$V1 %in% rowVector)set2$V3 = 0.0)
