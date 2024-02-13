# Read the relevant economic indicators data
df_inf <- read.csv("inflait_incl_EA.csv")
df_gdp <- read.csv("GDP_inc_ea19.csv")
df_pop <- read.csv("Population_inc_ea19.csv")

#Find the intersecting countires present in all the above dataframes
common <- as.data.frame(intersect(df_inf$Country.Name,df_gdp$Country.Name))
common <- as.data.frame(intersect(common[,1],df_pop$Country.Name))

# Choose the year for which you want to get the Economic indicators dataframe 
year <- "X2001"
#create dataframe with countries over economic indicators
df_inf_target_year <- subset(df_inf[df_inf$Country.Name %in% common[,1],], select = c(year))
df_gdp_target_year <- subset(df_gdp[df_gdp$Country.Name %in% common[,1],], select = c(year))
df_pop_target_year <- subset(df_pop[df_pop$Country.Name %in% common[,1],], select = c(year))
ecoind_target_year <- cbind(common[,1],df_inf_target_year,df_gdp_target_year,df_pop_target_year)
# Rename df columns accordingly and save
colnames(ecoind_target_year) <- c("Country.Name","Inflation","GDP","Population")
write.csv(ecoind_target_year,"economic_indicators_2001.csv",row.names = FALSE)
