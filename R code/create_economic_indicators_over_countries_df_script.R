library(tidyverse)

# Read the relevant economic indicators data
df_inf <- read.csv("data/inflation.csv")
df_gdp <- read.csv("data/gdp.csv")
df_pop <- read.csv("data/population_over_years.csv")
df_unemp <- read.csv("data/unemployment.csv")

#Find the intersecting countires present in all the above dataframes
common <- as.data.frame(intersect(df_unemp$Country.Code,df_gdp$Country.Code))
common <- as.data.frame(intersect(common[,1],df_pop$LOCATION))
common <- as.data.frame(intersect(common[,1],df_inf$LOCATION))

# Choose the year for which you want to get the Economic indicators dataframe 
years <- c("2017","2018","2019")

#create dataframe with countries over economic indicators
df_inf_target_year <- df_inf[df_inf$LOCATION %in% common[,1] & 
                              df_inf$TIME %in% years &
                              df_inf$SUBJECT == "TOT" &
                              df_inf$MEASURE=="AGRWTH",]
df_inf_target_year <- df_inf_target_year[,-c(2,3,4,5,8)]

df_inf_target_year_final <- df_inf_target_year[df_inf_target_year$TIME == "2017" ,]
df_inf_target_year_final$TIME <- NULL
colnames(df_inf_target_year_final) <- c("Country.Code","INF_2017")

df_inf_target_year_final$"INF_2018" <- df_inf_target_year[df_inf_target_year$TIME == "2018",3]
df_inf_target_year_final$"INF_2019" <- df_inf_target_year[df_inf_target_year$TIME == "2019",3]
df_inf_target_year_final <- df_inf_target_year_final %>% arrange(Country.Code)

df_pop_target_year <- df_pop[df_pop$LOCATION %in% common[,1] & 
                               df_pop$TIME %in% years &
                               df_pop$SUBJECT == "TOT",]
df_pop_target_year <- df_pop_target_year[,-c(2,3,4,5,8)]
df_pop_target_year_final <- df_pop_target_year[df_pop_target_year$TIME == "2017" ,]
df_pop_target_year_final$TIME <- NULL
colnames(df_pop_target_year_final) <- c("Country.Code","POP_2017")

df_pop_target_year_final$"POP_2018" <- df_pop_target_year[df_pop_target_year$TIME == "2018",3]
df_pop_target_year_final$"POP_2019" <- df_pop_target_year[df_pop_target_year$TIME == "2019",3]
df_pop_target_year_final <- df_pop_target_year_final %>% arrange(Country.Code)


df_gdp_target_year <- df_gdp[df_gdp$Country.Code %in% common[,1],]
df_gdp_target_year <- df_gdp_target_year[, -c(1,3,4,67)]
colnames(df_gdp_target_year) <- c("Country.Code", c(1960:2021))
df_gdp_target_year <- df_gdp_target_year[, c("Country.Code",years)]
colnames(df_gdp_target_year) <- c("Country.Code","GDP_2017","GDP_2018","GDP_2019")
df_gdp_target_year <- df_gdp_target_year %>% arrange(Country.Code)


df_unemp_target_year <- df_unemp[df_unemp$Country.Code %in% common[,1],]
df_unemp_target_year <- df_unemp_target_year[, -c(1,3,4,67)]
colnames(df_unemp_target_year) <- c("Country.Code", c(1960:2021))
df_unemp_target_year <- df_unemp_target_year[, c("Country.Code",years)]
colnames(df_unemp_target_year) <- c("Country.Code","UNEMP_2017","UNEMP_2018","UNEMP_2019")
df_unemp_target_year <- df_unemp_target_year %>% arrange(Country.Code)


df_list <- list(df_pop_target_year_final, df_inf_target_year_final, df_unemp_target_year, df_gdp_target_year)
pre.covid <- Reduce(function(x, y) merge(x, y, all=TRUE), df_list)
write.csv(pre.covid,"data/pre_covid.csv",row.names = FALSE)

#########################################post covid

years = c("2020","2021")

df_inf_target_year <- df_inf[df_inf$LOCATION %in% common[,1] & 
                               df_inf$TIME %in% years &
                               df_inf$SUBJECT == "TOT" &
                               df_inf$MEASURE=="AGRWTH",]
df_inf_target_year <- df_inf_target_year[,-c(2,3,4,5,8)]

df_inf_target_year_final <- df_inf_target_year[df_inf_target_year$TIME == "2020" ,]
df_inf_target_year_final$TIME <- NULL
colnames(df_inf_target_year_final) <- c("Country.Code","INF_2020")

df_inf_target_year_final$"INF_2021" <- df_inf_target_year[df_inf_target_year$TIME == "2021",3]
df_inf_target_year_final <- df_inf_target_year_final %>% arrange(Country.Code)


df_pop_target_year <- df_pop[df_pop$LOCATION %in% common[,1] & 
                               df_pop$TIME %in% years &
                               df_pop$SUBJECT == "TOT",]
df_pop_target_year <- df_pop_target_year[,-c(2,3,4,5,8)]
df_pop_target_year_final <- df_pop_target_year[df_pop_target_year$TIME == "2020" ,]
df_pop_target_year_final$TIME <- NULL
colnames(df_pop_target_year_final) <- c("Country.Code","POP_2020")

df_pop_target_year_final$"POP_2021" <- df_pop_target_year[df_pop_target_year$TIME == "2021",3]
df_pop_target_year_final <- df_pop_target_year_final %>% arrange(Country.Code)


df_gdp_target_year <- df_gdp[df_gdp$Country.Code %in% common[,1],]
df_gdp_target_year <- df_gdp_target_year[, -c(1,3,4,67)]
colnames(df_gdp_target_year) <- c("Country.Code", c(1960:2021))
df_gdp_target_year <- df_gdp_target_year[, c("Country.Code",years)]
colnames(df_gdp_target_year) <- c("Country.Code","GDP_2020","GDP_2021")
df_gdp_target_year <- df_gdp_target_year %>% arrange(Country.Code)


df_unemp_target_year <- df_unemp[df_unemp$Country.Code %in% common[,1],]
df_unemp_target_year <- df_unemp_target_year[, -c(1,3,4,67)]
colnames(df_unemp_target_year) <- c("Country.Code", c(1960:2021))
df_unemp_target_year <- df_unemp_target_year[, c("Country.Code",years)]
colnames(df_unemp_target_year) <- c("Country.Code","UNEMP_2020","UNEMP_2021")
df_unemp_target_year <- df_unemp_target_year %>% arrange(Country.Code)


df_list <- list(df_pop_target_year_final, df_inf_target_year_final, df_unemp_target_year, df_gdp_target_year)
post.covid <- Reduce(function(x, y) merge(x, y, all=TRUE), df_list)
write.csv(post.covid,"data/post_covid.csv",row.names = FALSE)
