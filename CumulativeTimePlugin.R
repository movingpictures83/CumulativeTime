require(graphics)
library("caret")
library("spls")
library(mlbench)
input <- function(inputfile) {
  parameters <<- read.table(inputfile, as.is=T);
  rownames(parameters) <<- parameters[,1];
  print("READING INPUT FILES...");
  t1 <<- read.table(toString(parameters["training",2]), sep = "\t", header =FALSE, stringsAsFactors=FALSE)#, nrow=20000)
  t2 <<- read.table(toString(parameters["clinical",2]), sep="\t", header = TRUE,  stringsAsFactors=FALSE)
  print("DONE");
}

run <- function() {
   t2[t2$STUDYID == "DEE4X H1N1",]$STUDYID <<- "H1N1"
   t2[t2$STUDYID == "DEE3 H1N1",]$STUDYID <<- "H1N1"
   t2[t2$STUDYID == "DEE2 H3N2",]$STUDYID <<- "H3N2"
   t2[t2$STUDYID == "DEE5 H3N2",]$STUDYID <<- "H3N2"
   t2[t2$STUDYID == "Rhinovirus Duke",]$STUDYID <<- "Rhinovirus"
   t2[t2$STUDYID == "Rhinovirus UVA",]$STUDYID <<- "Rhinovirus"

   t1 <<- as.data.frame(t(t1), stringsAsFactors=FALSE)
   colnames(t1)[1] = "CEL"
   x <<- merge(t1, t2, by ="CEL", stringsAsFactors=FALSE)

   v1 <<- subset(x, x$STUDYID == "DEE1 RSV")
   v1 <<- v1[order(v1$SUBJECTID),]

   #subjectsV1 <<- intersect(subset(v1$SUBJECTID, v1$TIMEHOURS==0),intersect(subset(v1$SUBJECTID, v1$TIMEHOURS==-24), intersect(subset(v1$SUBJECTID, v1$TIMEHOURS==5), intersect(subset(v1$SUBJECTID, v1$TIMEHOURS==12), intersect(subset(v1$SUBJECTID, v1$TIMEHOURS==36), intersect(subset(v1$SUBJECTID, v1$TIMEHOURS==21.5), subset(v1$SUBJECTID, v1$TIMEHOURS==45.5)))))))
   timesV1 <<- c(-24, 0, 5, 12, 21.5, 36, 45.5)
}

output <- function(outputfile) {
t.y = as.factor(v1[v1[,"TIMEHOURS"]==-24,22286])
# datX = matrix(nrow = length(subjectsV1), ncol = 22277)
#Create empty dataframe
for(t in timesV1){
  t.x <- data.matrix(v1[v1[,"TIMEHOURS"]==t,2:22278])
  # datX <- cbind(datX, t.x)
  #Join t.x to frame

  my_pls1 = plsda(t.x, t.y)

  res = order(varImp(my_pls1), decreasing = TRUE)[1:1000]

  # resCon = sapply(res, function(x) varImp(my_pls1)[1][[1]][x] > 0.01)
  # fin = res[resCon]
  imp = varImp(my_pls1)[1][[1]][c(res)]


  df = data.frame(res, imp)
  write.csv(df, file = paste(outputfile,t,".csv", sep=""), row.names = FALSE)

}
}

