dyn.load(paste("RPluMA", .Platform$dynlib.ext, sep=""))
source("RPluMA.R")


require(graphics)
library("caret")
library("spls")
library(mlbench)
input <- function(inputfile) {
  parameters <<- read.table(inputfile, as.is=T);
  rownames(parameters) <<- parameters[,1];
    pfix = prefix()
  if (length(pfix) != 0) {
     pfix <- paste(pfix, "/", sep="")
  }
  print("READING INPUT FILES...");
  target <<- toString(parameters["target", 2])
  t1 <<- read.table(paste(pfix, toString(parameters["training",2]), sep=""), sep = "\t", header =FALSE, stringsAsFactors=FALSE)#, nrow=20000)
  t2 <<- read.table(paste(pfix, toString(parameters["clinical",2]), sep=""), sep="\t", header = TRUE,  stringsAsFactors=FALSE)
  t3 <<- read.table(paste(pfix, toString(parameters["times",2]), sep=""))
  joinby <<- toString(parameters["joinby", 2])
  orderby <<- toString(parameters["orderby", 2])
  id <<- toString(parameters["id", 2])
  myX <<- toString(parameters["x", 2])
  classcol <<- toString(parameters["classcol", 2])
  print("DONE");
}

run <- function() {
   t1 <<- as.data.frame(t(t1), stringsAsFactors=FALSE)

colnames(t1)[1] = joinby
   x <<- merge(t1, t2, by =joinby, stringsAsFactors=FALSE)

   v1 <<- subset(x, as.character(unlist(x[id])) == target)
   #v1 <<- v1[order(v1$SUBJECTID),]
   v1 <<- v1[order(as.character(unlist(v1[orderby]))),]

   #subjectsV1 <<- intersect(subset(v1$SUBJECTID, v1$TIMEHOURS==0),intersect(subset(v1$SUBJECTID, v1$TIMEHOURS==-24), intersect(subset(v1$SUBJECTID, v1$TIMEHOURS==5), intersect(subset(v1$SUBJECTID, v1$TIMEHOURS==12), intersect(subset(v1$SUBJECTID, v1$TIMEHOURS==36), intersect(subset(v1$SUBJECTID, v1$TIMEHOURS==21.5), subset(v1$SUBJECTID, v1$TIMEHOURS==45.5)))))))
   #timesV1 <<- c(-24, 0, 5, 12, 21.5, 36, 45.5)
   timesV1 <<- as.numeric(unlist(t3))
   train_set_size <<- ncol(t1)
   class_index <<- grep(classcol, colnames(t2))
}

output <- function(outputfile) {
#t.y = as.factor(v1[v1[,"TIMEHOURS"]==-24,22286])
t.y = as.factor(v1[v1[,myX]==timesV1[1],(train_set_size+class_index)])
# datX = matrix(nrow = length(subjectsV1), ncol = 22277)
#Create empty dataframe
for(t in timesV1){
  print(t)
  t.x <- data.matrix(v1[v1[,myX]==t,2:train_set_size])
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

