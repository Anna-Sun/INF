# 11-8-2020 JHZ

require(gap)
t <- read.delim("INF1.tbl",as.is=TRUE)
tbl <- within(t, {
    prot <- sapply(strsplit(Chromosome,":"),"[",1)
    Chromosome <- sapply(strsplit(Chromosome,":"),"[",2)
})
## to obtain variance explained
tbl <- within(tbl,
{
  chi2n <- (Effect/StdErr)^2/N
  v <- (1-chi2n)^2/N
})
s <- with(tbl, aggregate(chi2n,list(prot),sum))
names(s) <- c("prot", "pve")
se2 <- with(tbl, aggregate(v,list(prot),sum))
names(se2) <- c("p1","v")
m <- with(tbl, aggregate(chi2n,list(prot),length))
names(m) <- c("p2","m")
pve <- cbind(s,se2,m)
ord <- with(pve, order(pve))
sink("pve.dat")
print(pve[ord, c("prot","pve","v","m")], row.names=FALSE)
sink()
write.csv(tbl,file="INF1.csv",quote=FALSE,row.names=FALSE)
