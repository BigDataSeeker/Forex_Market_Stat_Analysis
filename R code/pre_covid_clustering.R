library(cluster)
library(factoextra)
library(dplyr)
library(ggplot2)

set.seed(36)

pre.covid <- read.csv("data/pre_covid.csv")
countries <- pre.covid$Country.Code
pre.covid$Country.Code <- NULL
rownames(pre.covid) <- countries

summary(pre.covid)

##############################################PCA with scaled data
scaled <- data.frame(scale(pre.covid))
x11()
par(mfrow=c(4,3))
for (i in 1:12) {
  hist(scaled[,i], main=colnames(pre.covid)[i], xlab = NULL)
}

pc <- princomp(scaled, scores=T)
summary(pc)

loads <- pc$loadings
scores <- pc$scores

# Explained variance
x11()
layout(matrix(c(2,3,1,3),2,byrow=T))
plot(pc, las=2, main='Principal components')
barplot(sapply(pre.covid,sd)^2, las=2, main='Original Variables', ylab='Variances')
plot(cumsum(pc$sd^2)/sum(pc$sd^2), type='b', axes=F, xlab='number of components', 
     ylab='contribution to the total variance', ylim=c(0,1))
abline(h=1, col='blue')
abline(h=0.8, lty=2, col='blue')
box()
axis(2,at=0:10/10,labels=0:10/10)
axis(1,at=1:ncol(scaled),labels=1:ncol(scaled),las=2)

x11()
par(mar = c(2,2,2,1), mfrow=c(3,1))
for(i in 1:3)
  barplot(loads[,i], ylim = c(-1, 1), main=paste('Loadings PC ',i,sep=''))

pc.pre.covid <- data.frame(scores[,1:3])

x11()
pairs(pc.pre.covid, main="PCA on scaled data")

################################# PCA with softmax-scaled data

log.scaled <- pre.covid[-40,] #remove SAU because of negative values
for (i in 1:ncol(pre.covid)) {
  log.scaled[,i] <- log(log.scaled[,i])
}
log.scaled <- scale(log.scaled)

cor.mat <- cor(t(log.scaled))

x11()
par(mfrow=c(4,3))
for (i in 1:12) {
  hist(log.scaled[,i], main=paste("log-scaled ", colnames(log.scaled)[i]), xlab = NULL)
}

pc.log <- princomp(log.scaled, scores=T)
summary(pc.log)

# Explained variance
x11()
layout(matrix(c(2,3,1,3),2,byrow=T))
plot(pc.log, las=2, main='Principal components - log scaled data')
barplot(sapply(pre.covid,sd)^2, las=2, main='Original Variables', ylab='Variances')
plot(cumsum(pc.log$sd^2)/sum(pc.log$sd^2), type='b', axes=F, xlab='number of components', 
     ylab='contribution to the total variance', ylim=c(0,1))
abline(h=1, col='blue')
abline(h=0.8, lty=2, col='blue')
box()
axis(2,at=0:10/10,labels=0:10/10)
axis(1,at=1:ncol(scaled),labels=1:ncol(scaled),las=2)

loads <- pc.log$loadings
scores <- pc.log$scores

x11()
par(mar = c(2,2,2,1), mfrow=c(3,1))
for(i in 1:3)
  barplot(loads[,i], ylim = c(-1, 1), main=paste('Loadings PC - log-scaled data',i,sep=''))

pc.log.pre <- data.frame(scores[,1:3])

x11()
pairs(pc.log.pre, main="PCA on log-scaled data")

################################# k-means on log-scaled data

b <- NULL
w <- NULL
for(k in 1:10){
  
  result.k <- kmeans(pc.log.pre, k)
  w <- c(w, sum(result.k$wit))
  b <- c(b, result.k$bet)
  
}

x11()
matplot(1:10, w/(w+b), pch='', xlab='clusters', ylab='within/tot', main='Choice of k', ylim=c(0,1))
lines(1:10, w/(w+b), type='b', lwd=2)  #k=3

kmeans_clust = kmeans(pc.log.pre, centers = 3, nstart = 50)
x11()
fviz_cluster(kmeans_clust, data = pc.log.pre)

x11()
plot(pc.log.pre, col = kmeans_clust$cluster+1,main="k-means")

rownames(pc.log.pre[kmeans_clust$cluster==1,])
rownames(pc.log.pre[kmeans_clust$cluster==2,])
rownames(pc.log.pre[kmeans_clust$cluster==3,])

clustered <- pc.log.pre
clustered$clust <- kmeans_clust$cluster

sil <- silhouette(clustered$clust, dist(pc.log.pre))  
sil[,"sil_width"]  #the only negative value is -0.006701255, for EST
mean(sil[,"sil_width"]) #0.2502103

########################### bisecting k-means on log-scaled data  (draft)
bisec.log <- pc.log.pre
bisec.log$clust <- 1

bisecting_kmeans <- function(data, k) {
  # Initialize with a single cluster
  clusters <- list()
  clusters[[1]] <- data
  
  # Repeat until the desired number of clusters is reached
  while (length(clusters) < k) {
    # Select the cluster with the largest SSE (Sum of Squared Errors)
    cluster_index <- which.max(sapply(clusters, function(cluster) sum(dist(cluster)^2)))
    cluster_data <- clusters[[cluster_index]]
    
    # Perform regular K-means on the selected cluster
    kmeans_result <- kmeans(cluster_data, centers = 2)
    
    # Split the cluster into two subclusters
    subcluster1 <- cluster_data[kmeans_result$cluster == 1, ]
    subcluster2 <- cluster_data[kmeans_result$cluster == 2, ]
    
    # Remove the original cluster and add the subclusters
    clusters[[cluster_index]] <- NULL
    clusters <- c(clusters, list(subcluster1), list(subcluster2))
  }
  
  return(clusters)
}


# Apply the Bisecting K-means algorithm
k <- 3
resultk <- bisecting_kmeans(pc.log.pre, k)
resultk

for (i in 1:length(resultk)) {
  cl <- rownames(resultk[[i]])
  bisec.log[cl,4] <- i
}

x11()
plot(pc.log.pre, col = bisec.log$clust+1, main="Bisecting k-means")

sil <- silhouette(bisec.log$clust, dist(pc.log.pre))  
sil[,"sil_width"]  #the only negative value is -0.006701255, for EST
mean(sil[,"sil_width"]) #0.2502103











  