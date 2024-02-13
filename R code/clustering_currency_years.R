setwd("data")
df <- read.csv("currencies.csv")
library(cluster)
library(factoextra)

#df <- df[!(df$X == "RUB"),] #exclude Russia
curnames <- df[,c(1)]
df_t <- t(df[,2:22])
colnames(df_t) <- t(curnames)
df_t <- as.data.frame(df_t)

dft <- scale(df_t)
dft <- as.data.frame(dft)
df.pc <- princomp(t(dft))



fviz_nbclust(df_t, kmeans, method = 'wss')
kmeans_clust = kmeans(df_t, centers = 2, nstart = 50)
fviz_cluster(kmeans_clust, data = df_t)
