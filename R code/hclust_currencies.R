#Import libraries

library(mvtnorm)
library(MVN)
library(rgl)
library(car)
library(dbscan)
library(cluster)
library(fields)
library(lattice)
library(factoextra)

set.seed(10)

currencies <- read.csv("data/currencies.csv")
years <- c(2002:2022)
names <- currencies$X
currencies$X <- NULL
colnames(currencies) <- years
rownames(currencies) <- names

####################################################### HIERARCHICAL CLUSTERING

#distance matrices
euc.mat <- dist(currencies, method='euclidean')
man.mat <- dist(currencies, method='manhattan')
can.mat <- dist(currencies, method='canberra')

x11()
levelplot(as.matrix(euc.mat), main='metrics: Euclidean', asp=1, xlab='i', ylab='j' )

x11()
levelplot(as.matrix(can.mat), main='metrics: Canberra', asp=1, xlab='i', ylab='j' )

x11()
levelplot(as.matrix(man.mat), main='metrics: Manhattan', asp=1, xlab='i', ylab='j' )

graphics.off()

#as we can see, due to the largely different scale of different currencies, 
#the canberra distance seems to be the most realistic distance to use
#if we don't want to eliminate outliers


#hierarchical clustering
can.single <- hclust(can.mat, method='single')
can.average <- hclust(can.mat, method='average')
can.complete <- hclust(can.mat, method='complete')
can.ward <- hclust(can.mat, method='ward.D2')


# plot of the dendrograms
x11()
par(mfrow=c(2,2))
plot(can.single, main='canberra-single', hang=-0.1, xlab='', labels=F, cex=0.6, sub='')
plot(can.average, main='canberra-average', hang=-0.1, xlab='', labels=F, cex=0.6, sub='')
plot(can.complete, main='canberra-complete', hang=-0.1, xlab='', labels=F, cex=0.6, sub='')
plot(can.ward, main='canberra-ward', hang=-0.1, xlab='', labels=F, cex=0.6, sub='')


#as we can see from the single and average dendrograms, there is a 
#data point (IDR currency) which remains a single cluster until the last steps, so presumably 
#an outlier

#the ideal number of clusters for complete, single and average (including outlier) seems to be 3,
#whereas for ward linkage we try with 2 or 4


x11()
par(mfrow=c(1,4))
plot(can.single, main='canberra-single', hang=-0.1, xlab='', labels=F, cex=0.6, sub='')
rect.hclust(can.single, k=3)
plot(can.average, main='canberra-average', hang=-0.1, xlab='', labels=F, cex=0.6, sub='')
rect.hclust(can.average, k=3)
plot(can.complete, main='canberra-complete', hang=-0.1, xlab='', labels=F, cex=0.6, sub='')
rect.hclust(can.complete, k=3)
plot(can.ward, main='canberra-ward', hang=-0.1, xlab='', labels=F, cex=0.6, sub='')
rect.hclust(can.ward, k=2)

#cut dendrogram
cluster.cc <- cutree(can.complete, k=3) # canberra-complete
cluster.cs <- cutree(can.single, k=3) # canberra-single
cluster.ca <- cutree(can.average, k=3) # canberra-average
cluster.cw2 <- cutree(can.ward, k=2) # canberra-ward
cluster.cw4 <- cutree(can.ward, k=4) # canberra-ward


# interpret the clusters
table(label.cluster = cluster.cs) 
table(label.cluster = cluster.cc)
table(label.cluster = cluster.ca)  
table(label.cluster = cluster.cw2)
table(label.cluster = cluster.cw4)


#as expected, we find a singleton cluster for single and average linkage
#average and ward linkages produce the same result with the only difference of the outlier

# compute the cophenetic matrices 
coph.cc <- cophenetic(can.complete)
coph.ca <- cophenetic(can.average)
coph.cw <-  cophenetic(can.ward)
coph.cs <- cophenetic(can.single)

# compare with dissimilarity matrix (Canberra distance)
x11()
layout(rbind(c(0,1,0),c(2,3,4)))
image(as.matrix(can.mat), main='Canberra distance', asp=1 )
image(as.matrix(coph.cc), main='Complete', asp=1 )
image(as.matrix(coph.ca), main='Average', asp=1 )
image(as.matrix(coph.cw), main='Ward', asp=1 )


# compute cophenetic correlation coefficients
c(cor(can.mat, coph.cc),cor(can.mat, coph.ca), cor(can.mat, coph.cw))

#ward-linkage is good, but average-linkage provides a better result in terms of cophenetic coefficient. 

cluster.ca
sil <- silhouette(cluster.ca, dist(currencies, method="canberra"))
mean(sil[,"sil_width"]) #0.4005008
summary(sil)

cluster.cw2    
sil <- silhouette(cluster.cw2, dist(currencies, method="canberra"))
mean(sil[,"sil_width"]) #0.423189
summary(sil)

cluster.cw4
sil <- silhouette(cluster.cw4, dist(currencies, method="canberra"))
mean(sil[,"sil_width"]) #0.4929818
summary(sil) 

print("Clustering with Canberra distance-Ward linkage with k=4: ")
for (i in c(1:4)) {
  print(paste("Cluster", i, ":"))
  print(rownames(currencies[cluster.cw4==i,]))
}


###############################################
#repeat the same analysis with the percentage difference dataset

curr.diff <- data.frame(currencies[,1])

for (i in c(2:ncol(currencies))) {
  col1 <- currencies[,i-1]
  col2 <- currencies[,i]
  curr.diff[,i] <- (col2-col1)/col1
}

colnames(curr.diff) <- years
rownames(curr.diff) <- names
curr.diff[,1] <- NULL

#distance matrices
euc.mat <- dist(curr.diff, method='euclidean')
man.mat <- dist(curr.diff, method='manhattan')
can.mat <- dist(curr.diff, method='canberra')

x11()
levelplot(as.matrix(euc.mat), main='metrics: Euclidean', asp=1, xlab='i', ylab='j' )

x11()
levelplot(as.matrix(can.mat), main='metrics: Canberra', asp=1, xlab='i', ylab='j' )

x11()
levelplot(as.matrix(man.mat), main='metrics: Manhattan', asp=1, xlab='i', ylab='j' )

graphics.off()

#Canberra distance doesn't seem good and Euclidean and Manhattan have strong correlation, 
#so we only keep euclidean distance

#hierarchical clustering for euclidean distance
euc.single <- hclust(euc.mat, method='single')
euc.average <- hclust(euc.mat, method='average')
euc.complete <- hclust(euc.mat, method='complete')
euc.ward <- hclust(euc.mat, method='ward.D2')

#hierarchical clustering for canberra distance
can.single <- hclust(can.mat, method='single')
can.average <- hclust(can.mat, method='average')
can.complete <- hclust(can.mat, method='complete')
can.ward <- hclust(can.mat, method='ward.D2')


# plot of the dendrograms for euclidean distance
x11()
par(mfrow=c(2,2))
plot(euc.single, main='euclidean-single', hang=-0.1, xlab='', labels=F, cex=0.6, sub='')
plot(euc.average, main='euclidean-average', hang=-0.1, xlab='', labels=F, cex=0.6, sub='')
plot(euc.complete, main='euclidean-complete', hang=-0.1, xlab='', labels=F, cex=0.6, sub='')
plot(euc.ward, main='euclidean-ward', hang=-0.1, xlab='', labels=F, cex=0.6, sub='')

# plot of the dendrograms for canberra distance
x11()
par(mfrow=c(2,2))
plot(can.single, main='canberra-single', hang=-0.1, xlab='', labels=F, cex=0.6, sub='')
plot(can.average, main='canberra-average', hang=-0.1, xlab='', labels=F, cex=0.6, sub='')
plot(can.complete, main='canberra-complete', hang=-0.1, xlab='', labels=F, cex=0.6, sub='')
plot(can.ward, main='canberra-ward', hang=-0.1, xlab='', labels=F, cex=0.6, sub='')

#Strong chain effect for both single and average linkage in euclidean distance, and for single linkage 
#in canberra distance. We discard them all.
#All the other Ward dendrograms suggest clearly k=3, as for the Euclidean ones which are more influenced
#by little clusters though.

x11()
par(mfrow=c(1,3))
plot(can.average, main='canberra-average', hang=-0.1, xlab='', labels=F, cex=0.6, sub='')
rect.hclust(can.average, k=3)
plot(can.complete, main='canberra-complete', hang=-0.1, xlab='', labels=F, cex=0.6, sub='')
rect.hclust(can.complete, k=3)
plot(can.ward, main='canberra-ward', hang=-0.1, xlab='', labels=F, cex=0.6, sub='')
rect.hclust(can.ward, k=3)

x11()
par(mfrow=c(1,2))
plot(euc.complete, main='euclidean-complete', hang=-0.1, xlab='', labels=F, cex=0.6, sub='')
rect.hclust(euc.complete, k=3)
plot(euc.ward, main='euclidean-ward', hang=-0.1, xlab='', labels=F, cex=0.6, sub='')
rect.hclust(euc.ward, k=3)

#cut dendrogram
cluster.cc <- cutree(can.complete, k=3) # canberra-complete
cluster.ca <- cutree(can.average, k=3) # canberra-average
cluster.cw <- cutree(can.ward, k=3) # canberra-ward
cluster.ec <- cutree(euc.complete, k=3) # euclidean-complete
cluster.ew <- cutree(euc.ward, k=3) # euclidean-ward

# interpret the clusters
table(label.cluster = cluster.cc)
table(label.cluster = cluster.ca)
table(label.cluster = cluster.cw)
table(label.cluster = cluster.ec)
table(label.cluster = cluster.ew)


# compute the cophenetic matrices 
coph.cc <- cophenetic(can.complete)
coph.ca <- cophenetic(can.average)
coph.cw <-  cophenetic(can.ward)
coph.ec <- cophenetic(euc.complete)
coph.ew <-  cophenetic(euc.ward)

# compute cophenetic correlation coefficients
c(cor(can.mat, coph.cc),cor(can.mat, coph.ca), cor(can.mat, coph.cw)) #horrible result
c(cor(euc.mat, coph.ec), cor(euc.mat, coph.ew))  #euclidean complete has good cophenetic coefficient


cluster.ca
sil <- silhouette(cluster.ca, dist(curr.diff, method="canberra"))
mean(sil[,"sil_width"]) #0.2129464
summary(sil) 

cluster.cw 
sil <- silhouette(cluster.cw, dist(curr.diff, method="canberra"))
mean(sil[,"sil_width"]) #0.2773354
summary(sil)  

cluster.cc 
sil <- silhouette(cluster.cc, dist(curr.diff, method="canberra"))
mean(sil[,"sil_width"]) #0.04011803 with negative coefficients
summary(sil)  

cluster.ec 
sil <- silhouette(cluster.ec, dist(curr.diff, method="euclidean"))
mean(sil[,"sil_width"]) #0.4709412 
summary(sil)  

cluster.ew 
sil <- silhouette(cluster.ew, dist(curr.diff, method="euclidean"))
mean(sil[,"sil_width"]) #0.3844153 
summary(sil)  
 

