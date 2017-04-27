setwd("/home/starship9/Desktop/SNU/Data Mining/CSD342_DataMining/NonGradedAssignmentR")

#creating a function for visualising the frequent itemsets of a file x, and the min supp threshold freq
genWordGraph<-function(x,freq){
  library(tm)
  #taking the raw text  
  raw.text<-scan(x,what="char",sep="")
  #head(raw.text)
  #converting to lower case
  raw.text<-tolower(raw.text)
  #raw.text <- tm_map(raw.text, removeWords, stopwords("english"))
  #whatsappDF$V6<-gsub('\\Saini+', '', whatsappDF$V6)
  #raw.text<-gsub('+a+','',raw.text)
  #raw.text<-gsub('+an+','',raw.text)
  #raw.text<-gsub('+of+','',raw.text)
  #raw.text<-gsub('+is+','',raw.text)
  #raw.text<-gsub('+the+','',raw.text)
  #raw.text<-gsub('+and+','',raw.text)
  #raw.text<-gsub('+is+','',raw.text)
  #raw.text<-tm_map(x,removeWords,stopwords("english"))
  #splitting wrt whitespace
  wordList.txt<-strsplit(raw.text,"\\W+",perl=TRUE)
  #head(wordList.txt)
  
  #storing a list as a vector
  wordVector.txt<-unlist(wordList.txt)
  #head(wordVector.txt)
  
  #using table() to get the frequency count
  text.freq.list<-table(wordVector.txt)
  #text.freq.list
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
  #textMoreThan10Freq<-gsub('\\a+', '', textMoreThan10Freq)
  #textMoreThan10Freq<-gsub('\\an+', '', textMoreThan10Freq)
  #textMoreThan10Freq<-gsub('\\the+', '', textMoreThan10Freq)
  #textMoreThan10Freq<-gsub('\\was+', '', textMoreThan10Freq)
  head(textMoreThan10Freq)
  #text.sortedFreq.list <- sort(text.freq.list)
  #head(text.sortedFreq.list)
  #text.sortedFreq.list
  #text.sortedTable<-paste(names(text.sortedFreq.list),text.sortedFreq.list,sep="    ")
  #head(text.sortedTable)
  #library(ggplot2)
  
  #graph
 # g<-ggplot(textMoreThan10Freq,aes(x=textMoreThan10Freq$Word, y = textMoreThan10Freq$Frequency, fill = textMoreThan10Freq$Word)) + geom_bar(stat="identity") + labs(x = "Word", y = "Frequency", title = "Non Graded Assignment")
  #getwd()
#  return (g)
  
  library(arules)
  
  #textMoreThan10Freq$Word<-discretize(as.String(textMoreThan10Freq$Word))
  #textMoreThan10Freq$Frequency<-discretize(as.numeric(textMoreThan10Freq$Frequency))
  data <- data.frame(sapply(textMoreThan10Freq,as.factor))
  
  rules<-apriori(data)
  arules::inspect(rules)
  rules.sorted<-sort(rules,by="lift")
  arules::inspect(rules.sorted)
  
  library(arulesViz)
  
  plot(rules, method="graph", control=list(type="items"))
}
#graph for the larger text file

genWordGraph("largeTxt.txt",2000)

#graph for the smaller text file
genWordGraph("ngla1.txt",10)

#library(wordcloud)
#wordcloud(textMoreThan10Freq$Word,  random.order = FALSE, max.words = 100, col = brewer.pal(10,"Set3"))

