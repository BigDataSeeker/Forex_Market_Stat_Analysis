
# Analysis of the foreign exchange market

**The goal** of this project is to investigate the foreign exchange market, in particular to find which are the factors that impact the most on the exchange rates, to discover hiddden patterns and similarities among different currency areas, to understand whether is possible to forecast future behaviour of the market and to study how big events (e.g wars, natural calamities or economic crisis) reflect on it.

This repo contains the resutls and description of the Forex market analysis, as well as data and R code used during the project deveopment. 

## Introduction

The Foreign Exchange market is the biggest market in the world with daily trading volumes of more than trillions of dollars, operating 24 hours each work day. As such, it's assumed to contain a lot of information about the world financial situation and about the relationships among countries and their currencies.

## Data description

**2 different data structures:**

- **Country-wise perspective:** in order to study which are the indicators that mostly influence the market, for each of the main currencies (US dollar, Euro,Yen and Ruble) consider the values of the most known economic indicators over the last 20 years.

- **Currency-wise perspective:** for the purpose of investigating which currencies are most influential upon each other and in this way capturing economical relationships between different countries, a time series for the last 20 years considering all the currencies were used.

![image](https://github.com/BigDataSeeker/Forex_Market_Stat_Analysis/blob/main/Main_findings_imgs/Currencies_vs_dollar_summary.jpg)

## Methods

- Principal Component Analysis

- ARMA and VAR models for time-series forecasting

- Hierarchical agglomerative clustering

- k-means clustering

- Funcitonal Data Analysis

- Correlation Analysis

### Principal Component Analysis

In the context of the country-wise perspective, using PCA was useful to have a preliminary understanding on how each currency is influenced by every economic factor. The following indicators are considered:

- Unemployment rate

- Interest rate

- Inflation rate

- Gross Domestic Product (GDP)

- Unemployment rate

- Government reserve amount

- Research and Development investment

- Population

**The analysis results evidenced that, generally, high values for unemployment, interest rates and inflation are the main repsonsibles for the loss of strength of the currency, whereas the increase of GDP favours solidity.**

For example, below you can see the results of PCA for the Russian economy 1997 - 2021. 

**Loadings of principal components** for Russia: 

- **PC1**: Unemployment rate with **-0.581**, Inflation rate with **-0.524**, GDP with **0.488**, Short term interest rate with **-0.386**

- **PC2**: Population with **0.931**, Inflation rate with **-0.124**, Short term interest rate with **0.335**   

The scores plot of the years in the space of two main principal components are depicted below: 

![image](https://github.com/BigDataSeeker/Forex_Market_Stat_Analysis/blob/main/Main_findings_imgs/Russia_PCA.PNG)

As you can notice, there's an abrupt distinction between the pre-2014 and post-2014 periods. An interpretation may be driven by the fact that Russia was sanctoined in 2014. 

**According to the first PC** accounting for the growth of GDP and is inverse proportional to malicious economic factors such as inflation, we can see that Russian economy had definitely positive dynamic in 1997-2013, but in 2014-2021 it got stuck and the development singinficantly slowed down. **According to the second PC** accounting mostly for the populatin, we see that in 1997-2007 the population had been decreasing, and in 2007-2021 the population had been growing with abrupt increase after 2014. 

### Clustering

Adopted clustering techniques allowed to find possible groupings among similar countries in different situations. Clutering is applied on the the dollar/currency rates along 2002-2022.

An interesting insight was to study the discrepancies among the obtained clusters when we focus on the main big events such as COVID pandemic: how did the grouping change from the 3 years before the event to the 3 years after the event?

![image](https://github.com/BigDataSeeker/Forex_Market_Stat_Analysis/blob/main/Main_findings_imgs/Pre-COVID_clustering.PNG)

![image](https://github.com/BigDataSeeker/Forex_Market_Stat_Analysis/blob/main/Main_findings_imgs/Post-COVID_clustering.PNG)

According to the results depicted above, there's a drastic change in the forex market after COVID-19 pandemic. 

Let's also apply clustering on the whole 2002-2022 perdiod without division into periods. For this purpose K-means algorithm was used.

![image](https://github.com/BigDataSeeker/Forex_Market_Stat_Analysis/blob/main/Clustering_imgs/clust_curr.png)

We see that Turkish Lira is definitely an outlier, probably due to its extraordinary inflation in 2022. But apart from this, it's not easy to interpret such clutering results.

Let's change the perspective and try to cluster Years in the space of country currencies:

![image](https://github.com/BigDataSeeker/Forex_Market_Stat_Analysis/blob/main/Clustering_imgs/Clustering_years_k-means_Rus_incl.jpg)

We see that there's a clear distinciton between pre-2014 and post-2014 periods. Moreover, we can notice that the year 2022 is highly biased from the mean of its cluster which is again known for the events linked to Russia. 

Let's exclude Russian currency from the analysis as it may affect the overall clutering results.

![image](https://github.com/BigDataSeeker/Forex_Market_Stat_Analysis/blob/main/Clustering_imgs/Clustering_years_k-means_Rus_excl.png)

![image](https://github.com/BigDataSeeker/Forex_Market_Stat_Analysis/blob/main/Clustering_imgs/WSS_elbow_plot_Rus_excl.png)

After the exclusion of Russia the clustering hasn't changed.

We can see evident results: There's dramatic changes in the currencies rates after 2014 and likely after 2022 too that affected most of the currencies. It may hint on the conclusion e.g. that sanctions on Russia affeced the overall Foreign market


### Correlation analysis

In order to see what currencies are interrelated to each other, the Correlation analysis on the the the dollar/currency rates along 2002-2022 was applied.

![image](https://github.com/BigDataSeeker/Forex_Market_Stat_Analysis/blob/main/Main_findings_imgs/Currencies_corrmatr.jpg)

From the Correlation matrix above we can see, for example, that the currencies of Europenian countries are positively correlated.

Let's change the perspective and see what are the correlations of the Years in the space of currencies.

![image](https://github.com/BigDataSeeker/Forex_Market_Stat_Analysis/blob/main/Main_findings_imgs/Correlation_matrix_currencies_vs_years.jpg)

The Correlation plot above probably says about some sort of flipping changes in the Foreign exchange market: the currecncies that were on average stronger against dollar in 2002-2012 wrt other currencies became on average weaker against dollar in 2012-2022 wrt other currencies. And the weaker ones became stronger.


### Functional data analysis

After having performed Fourier-based smoothing on the currencies exchange rates over years dataset, a Functional Principal Components Analysis was performed.

Grouping of the smoothed data is presented in the image below: Argentina is an outlier since the country has been going through political instability and high inflation after the pandemic

![image](https://github.com/BigDataSeeker/Forex_Market_Stat_Analysis/blob/main/Main_findings_imgs/Grouping_smoothed_data.PNG)

The obtained results show a clear distinction between currencies: 

![image](https://github.com/BigDataSeeker/Forex_Market_Stat_Analysis/blob/main/Main_findings_imgs/FPA_loadings_plot.jpg)

- the 1st FPC discriminates between those who lost strength to the US dollar after 2014 and those who didn’t

- the 2nd FPC considers the stability of the currency


Thus, the corresponding scores of the currencies of the countries in the space of two main FPC are as below:

![image](https://github.com/BigDataSeeker/Forex_Market_Stat_Analysis/blob/main/Main_findings_imgs/Scores_in_FPCA_plot.jpg)

### Timeseries Forecasting

In this part of the analysis the aim was to predict the value of the 62 countries’ currencies in 2022. For these purposes past values were used to do prediction. Different ARMA models were fitted by minimizing AIC for parameter selection. In the figure below you can see the standardized prediction errors for 6 countries: 3 for best predictions and 3 for worst predictions. They are 2022 standardized forecast errors of Costa Rica, Mexico, Madagascar, Türkiye, Korea and Japan. 

![image](https://github.com/BigDataSeeker/Forex_Market_Stat_Analysis/blob/main/Main_findings_imgs/2022_standardized_forecast_errors_CostaRica_Mexico_Madagascar_T%C3%BCrkiye_Korea_Japan.PNG)

Also, the image below shows the best and worst predictions. They are Türkiye and Madagascar. They both lose value against dollar.

![image](https://github.com/BigDataSeeker/Forex_Market_Stat_Analysis/blob/main/Main_findings_imgs/Standardized_currency_vs_dollar_over_years_T%C3%BCrkiye_Madagascar_forecasts2022.PNG)

Moreover the prediction was done also in the country-wise perspective for Norway. For ARMA model, just past values of exchange rate are used and for VAR model exhange rate, inflation, interest rate, current account balance, GDP per capita, population, unemployment, renewable energy spending and Research and Development spending are used.

![image](https://github.com/BigDataSeeker/Forex_Market_Stat_Analysis/blob/main/Main_findings_imgs/NorwegianKrone_forecast2021.PNG)


## Web references

- [OECD](https://www.oecd.org/)

- [The world bank data](https://data.worldbank.org/)
