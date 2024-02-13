library(ggplot2)
library(cluster)
library(factoextra)

df <- read.csv("post_covid.csv")
countries <- df[,1]
rownames(df) <- c(countries)
df <- df[,2:9]
pca_df <- prcomp(df, center = TRUE, scale = TRUE)
df_trsf <- as.data.frame(pca_df$x[,1:4])
fviz_nbclust(df_trsf, kmeans, method = 'wss')
kmeans = kmeans(df_trsf,center = 5, nstart = 50)
fviz_cluster(kmeans,data = df_trsf)
