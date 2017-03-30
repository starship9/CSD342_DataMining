setwd("/home/starship9/Desktop/SNU/Data Mining/CSD342_DataMining/NonGradedAssignmentR")

#creating a function for visualising the frequent itemsets of a file x, and the min supp threshold freq
genWordGraph<-function(x,freq){

#taking the raw text  
raw.text<-scan(x,what="char",sep="")
#head(raw.text)
#converting to lower case
raw.text<-tolower(raw.text)
#splitting wrt whitespace
wordList.txt<-strsplit(raw.text,"\\W+",perl=TRUE)
#head(wordList.txt)

#storing a list as a vector
wordVector.txt<-unlist(wordList.txt)
#head(wordVector.txt)

#using table() to get the frequency count
text.freq.list<-table(wordVector.txt)
library(dplyr)

#converting into a DF
textDF<-tbl_df(text.freq.list)
#head(textDF,30)
#View(textDF)
#textDF$n
#textDF$wordVector.txt
colnames(textDF)<-c("Word","Frequency")
head(textDF)
#selecting a random variable
sample_n(textDF,1)

#getting valid itemsets
textMoreThan10Freq<-filter(textDF,textDF$Frequency>freq)
head(textMoreThan10Freq)
#text.sortedFreq.list <- sort(text.freq.list)
#head(text.sortedFreq.list)
#text.sortedFreq.list
#text.sortedTable<-paste(names(text.sortedFreq.list),text.sortedFreq.list,sep="    ")
#head(text.sortedTable)
library(ggplot2)

#graph
g<-ggplot(textMoreThan10Freq,aes(x=textMoreThan10Freq$Word, y = textMoreThan10Freq$Frequency, fill = textMoreThan10Freq$Word)) + geom_bar(stat="identity")
#getwd()
return (g)
}
#graph for the larger text file
genWordGraph("largeTxt.txt",2000)

#graph for the smaller text file
genWordGraph("ngla1.txt",10)



