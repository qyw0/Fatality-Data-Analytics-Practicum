re <- read.csv(file = "result.csv",header = T)
library(sqldf)
library(igraph)

#Single
one <- subset(re,code2==''|code1==two3$code1|code1==two3$code2)
one <- sqldf('select code1,sum(freq) from one group by code1')
colnames(one) <- c('code1','freq')
#Pairs
two <- subset(re,code3=='')
two <- two[,c("code1","code2","freq")]
two1 <- subset(two,code2 != '')
two2 <- sqldf::sqldf("select code1,code2,sum(freq) from two1 group by code1,code2")
colnames(two2) <- c('code1', 'code2', 'weight')

s1 <- sqldf("select code1 as id,count(code1) as c from two2 group by code1")
s2 <- sqldf("select code2 as id,count(code2) as c from two2 group by code2")
s3 <- rbind(s1,s2)
s3 <- sqldf("select id,sum(c) as c from s3 group by id")
s3 <- sqldf("select id from s3 where c > 3")

#network plot drawing function
networkplot <- function(code){
  two3 <- subset(two2,(code1==code|code2==code))
  two3<- sqldf('select * from two3 order by weight desc limit 30')
  
  one <- subset(re,code2=='')
  one <- sqldf('select code1,sum(freq) from one group by code1')
  colnames(one) <- c('code1','freq')
  one1 <- sqldf('select * from one where 
                code1 in (select code1 from two3) or code1 in (select code2 from two3)')
  one1 <- unique(one1)
  g <- graph_from_data_frame(d=two3,vertices = one1, directed = FALSE)
  #l <- layout_on_sphere(g)
  l <- layout.reingold.tilford(g, circular=T)
  E(g)$width <- E(g)$weight/100000
  V(g)$size <- log(V(g)$freq/10000)*3.5
  
  plot(g, layout=l,vertex.label.font=.6,vertex.label.cex=1,  
       vertex.color='salmon',vertex.label.color="gray20",vertex.frame.color="grey80",
       edge.curved=0, edge.color="grey30")
}