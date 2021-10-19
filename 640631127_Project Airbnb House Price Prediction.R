####################################################################################
###################  AirBNB House Price Prediction in New York #####################
##################### Weerinphas Chimnam StudentID 590510386 #######################
####################################################################################


# Packages Required
#install.packages("dplyr")
#install.packages("corrplot")
#install.packages("tidyverse")
#install.packages("ggplot2")
#install.packages("visdat")
#install.packages("ggcorrplot")
#install.packages("leaps")
#install.packages("ggResidpanel")


# Loading the packages
library(dplyr)
library(corrplot)
library(tidyverse)
library(ggplot2)
library(visdat)
library(ggcorrplot)
library(leaps)
library(ggResidpanel)


# Setting the working directory
setwd("C:/Users/Pattamaporn/Master/Statistics/Final/TermProject")

# Loading the data
airbnb_data <- read.csv(file="AB_NYC_2019.csv")

# View the data
airbnb_data


#===================================================================
# 1. Preparing the data
#===================================================================

# Dropping irrelevant variables based on initial manual selection
#   drop column which we don't use such as id, name, host id,host name and last_review column
airbnb_data = airbnb_data[,-(1:4)]
airbnb_data <- subset(airbnb_data, select = c(-last_review))
#   We already have neighbourhood_group column, so we can drop neighbourhood column
airbnb_data <- subset(airbnb_data, select = c(-neighbourhood))

# Change some column name to shorter name
colnames(airbnb_data)

airbnb_data <- airbnb_data %>%
  rename(min_nights = minimum_nights,
         host_listings_count = calculated_host_listings_count)

# Summary of the data
summary(airbnb_data)
glimpse(airbnb_data)



#===================================================================
# 2. Exploratory Data Analysis (EDA)
#===================================================================

# Which Type of Listings are there in the Neighbourhood?
property_df <-  airbnb_data %>% 
  group_by(neighbourhood_group, room_type) %>% 
  summarize(Freq = n())

total_property <-  airbnb_data %>% 
  filter(room_type %in% c("Private room","Entire home/apt","Entire home/apt")) %>% 
  group_by(neighbourhood_group) %>% 
  summarize(sum = n())

property_ratio <- merge (property_df, total_property, by="neighbourhood_group")

property_ratio <- property_ratio %>% 
  mutate(ratio = Freq/sum)

ggplot(property_ratio, aes(x=neighbourhood_group, y = ratio, fill = room_type)) +
  geom_bar(position = "dodge", stat="identity") + 
  xlab("Borough") + ylab ("Count") +
  scale_fill_discrete(name = "Property Type") + 
  scale_y_continuous(labels = scales::percent) +
  ggtitle("Which types of Listings are there in NYC?",
          subtitle = "Map showing Count of Listing Type by Borough ") +
  theme(plot.title = element_text(face = "bold", size = 14) ) +
  theme(plot.subtitle = element_text(face = "bold", color = "grey35", hjust = 0.5)) +
  theme(plot.caption = element_text(color = "grey68"))+scale_color_gradient(low="#d3cbcb", high="#852eaa")+
  scale_fill_manual("Property Type", values=c("#e06f69","#357b8a", "#7db5b8", "#59c6f3", "#f6c458")) +
  xlab("Neighborhood") + ylab("Percentage")

# Average Price Comparison for each Neighbourhood Group
airbnb_data %>% 
  filter(!(is.na(neighbourhood_group))) %>% 
  filter(!(neighbourhood_group == "Unknown")) %>% 
  group_by(neighbourhood_group) %>% 
  summarise(mean_price = mean(price, na.rm = TRUE)) %>% 
  ggplot(aes(x = reorder(neighbourhood_group, mean_price), y = mean_price, fill = neighbourhood_group)) +
  geom_col(stat ="identity", color = "black", fill="#357b8a") +
  coord_flip() +
  theme_gray() +
  labs(x = "Neighbourhood Group", y = "Price") +
  geom_text(aes(label = round(mean_price,digit = 2)), hjust = 2.0, color = "white", size = 3.5) +
  ggtitle("Average Price comparison for each Neighbourhood Group", subtitle = "Price vs Neighbourhood Group") + 
  xlab("Neighbourhood Group") + 
  ylab("Average Price") +
  theme(legend.position = "none",
        plot.title = element_text(color = "black", size = 14, face = "bold", hjust = 0.5),
        plot.subtitle = element_text(color = "darkblue", hjust = 0.5),
        axis.title.y = element_text(),
        axis.title.x = element_text(),
        axis.ticks = element_blank())

# Average Price Comparison for each Room Type
airbnb_data %>% 
  filter(!(is.na(room_type))) %>% 
  filter(!(room_type == "Unknown")) %>% 
  group_by(room_type) %>% 
  summarise(mean_price = mean(price, na.rm = TRUE)) %>% 
  ggplot(aes(x = reorder(room_type, mean_price), y = mean_price, fill = room_type)) +
  geom_col(stat ="identity", color = "black", fill="#357b8a") +
  coord_flip() +
  theme_gray() +
  labs(x = "Room Type", y = "Price") +
  geom_text(aes(label = round(mean_price,digit = 2)), hjust = 2.0, color = "white", size = 3.5) +
  ggtitle("Average Price comparison with all Room Types", subtitle = "Price vs Room Type") + 
  xlab("Room Type") + 
  ylab("Average Price") +
  theme(legend.position = "none",
        plot.title = element_text(color = "black", size = 14, face = "bold", hjust = 0.5),
        plot.subtitle = element_text(color = "darkblue", hjust = 0.5),
        axis.title.y = element_text(),
        axis.title.x = element_text(),
        axis.ticks = element_blank())


#===================================================================
# 3. Data cleaning
#===================================================================

# 1) Deal with missing value

#    Check missing values
sum(is.na(airbnb_data))
summary(is.na(airbnb_data))

#    Visualize of missing values
airbnb_data %>%
  arrange(reviews_per_month) %>%
  vis_miss

#    Drop missing values in reviews_per_month column
data_cleaned <- airbnb_data %>%
  filter(!is.na(reviews_per_month))

#    Removing all observations where price is 0 since this is erroneous data
data_cleaned = data_cleaned[!data_cleaned$price==0,] 



# 2) Deal with outliers (numeric variables only)
#    First, dividing the dataset into quantitative and qualitative dataset

#    Select non-numeric features
chrVars <- which(sapply(data_cleaned, is.character)) # isolate the non-numeric variables
chrVars_all <- data_cleaned[, chrVars] #construct all frame

#    Select only numeric features
numVars <- which(sapply(data_cleaned, is.numeric)) # isolate the numeric variables
numVars_all <- data_cleaned[, numVars] #construct all frame

#    Checking numerical data before removing outliers
boxplot(numVars_all, main = "data distribution before removing outliers")


#    Checking outliers of each numeric variable
numVars_all2 <- numVars_all # Copy old dataset
outvalue<-list() 
outindex<-list()
for(i in 1:ncol(numVars_all2)){ # For every column in dataset
  outvalue[[i]]<-boxplot(numVars_all2[,i], horizontal = T, main = names(numVars_all2[i]))$out # Plot and get the outlier value
  outindex[[i]]<-which(numVars_all2[,i] == outvalue[[i]]) # Get the outlier index
}

#    Removing the outliers
colnames(data_cleaned)

#    price column
Q <- quantile(data_cleaned$price, probs=c(.25, .75), na.rm = T)
IQR <- IQR(data_cleaned$price, na.rm = T)
data_cleaned_outlier <- data_cleaned %>% filter(price > (Q[1] - 1.5*IQR) & price < (Q[2] + 1.5*IQR))

#    min_nights column
Q <- quantile(data_cleaned_outlier$min_nights, probs=c(.25, .75), na.rm = T)
IQR <- IQR(data_cleaned_outlier$min_nights, na.rm = T)
data_cleaned_outlier <- data_cleaned_outlier %>% filter(min_nights > (Q[1] - 1.5*IQR) & min_nights < (Q[2] + 1.5*IQR))

#    number_of_reviews column
Q <- quantile(data_cleaned_outlier$number_of_reviews, probs=c(.25, .75), na.rm = T)
IQR <- IQR(data_cleaned_outlier$number_of_reviews, na.rm = T)
data_cleaned_outlier <- data_cleaned_outlier %>% filter(number_of_reviews > (Q[1] - 1.5*IQR) & number_of_reviews < (Q[2] + 1.5*IQR))

#    reviews_per_month column
Q <- quantile(data_cleaned_outlier$reviews_per_month, probs=c(.25, .75), na.rm = T)
IQR <- IQR(data_cleaned_outlier$reviews_per_month, na.rm = T)
data_cleaned_outlier <- data_cleaned_outlier %>% filter(reviews_per_month > (Q[1] - 1.5*IQR) & reviews_per_month < (Q[2] + 1.5*IQR))

#    host_listings_count column
Q <- quantile(data_cleaned_outlier$host_listings_count, probs=c(.25, .75), na.rm = T)
IQR <- IQR(data_cleaned_outlier$host_listings_count, na.rm = T)
data_cleaned_outlier <- data_cleaned_outlier %>% filter(host_listings_count > (Q[1] - 1.5*IQR) & host_listings_count < (Q[2] + 1.5*IQR))

#    availability_365 column
Q <- quantile(data_cleaned_outlier$availability_365, probs=c(.25, .75), na.rm = T)
IQR <- IQR(data_cleaned_outlier$availability_365, na.rm = T)
data_cleaned_outlier <- data_cleaned_outlier %>% filter(availability_365 > (Q[1] - 1.5*IQR) & availability_365 < (Q[2] + 1.5*IQR))


#    Checking numerical data after removing outliers
numVars_cleaned <- which(sapply(data_cleaned_outlier, is.numeric)) # isolate the numeric variables
numVars_all_cleaned <- data_cleaned_outlier[, numVars_cleaned] # construct all frame

#    Checking for all numeric variables
boxplot(numVars_all_cleaned, main = "data distribution after removing outliers")

#    Checking for each numeric variable
numVars_all_cleaned2 <- numVars_all_cleaned # Copy old dataset
outvalue<-list() 
outindex<-list()
for(i in 1:ncol(numVars_all_cleaned2)){ # For every column in dataset
  outvalue[[i]]<-boxplot(numVars_all_cleaned2[,i], horizontal = T, main = names(numVars_all_cleaned2[i]))$out # Plot and get the outlier value
  outindex[[i]]<-which(numVars_all_cleaned2[,i] == outvalue[[i]]) # Get the outlier index
}

#    Checking the histogram before and after removing outliers
hist(airbnb_data$price, xlab="Price", main = "Histrogram of Price before cleaning")
hist(numVars_all_cleaned$price, xlab="Price", main = "Histrogram of Price after cleaning")

#===================================================================
# 4. Correlation
#===================================================================

# Correlation plot
numVars_all_cleaned.cor = cor(numVars_all_cleaned, method = c("pearson"))
numVars_all_cleaned.cor
corrplot(cor = numVars_all_cleaned.cor)


ggcorr(numVars_all_cleaned, method = c("everything", "pearson")) 
pairs(numVars_all_cleaned, main="scatterplot matrix")


#===================================================================
# 5. Split data into training set (10%) and testing set (90%)
#===================================================================

# random sampling
set.seed(80)
samplesize = 0.9*nrow(data_cleaned_outlier)
index = sample(seq_len(nrow(data_cleaned_outlier)), size=samplesize)

# create training and test set
trainning_data = data_cleaned_outlier[index,]
testing_data = data_cleaned_outlier[-index,]


#===================================================================
# 6. Modelling
#===================================================================

# To do the hypothesis testing at the level of significant 0.05
# t-test: check relationship between X and Y (for quantitative variables)
colnames(numVars_all_cleaned)

# H0: rho = 0 --> They have "no relationship" between X and Y
# Ha: rho != 0 --> They have "linear relationship" between X and Y

cor.test(trainning_data$latitude, trainning_data$price, method="pearson") #P-value = 2.231e-06
cor.test(trainning_data$longitude, trainning_data$price, method="pearson") #P-value < 2.2e-16
cor.test(trainning_data$minimum_nights, trainning_data$price, method="pearson") #P-value = 1.228e-08
cor.test(trainning_data$number_of_reviews, trainning_data$price, method="pearson") #P-value = 0.0001939
cor.test(trainning_data$reviews_per_month, trainning_data$price, method="pearson") #P-value < 2.2e-16
cor.test(trainning_data$calculated_host_listings_count, trainning_data$price, method="pearson") #P-value < 2.2e-16
cor.test(trainning_data$availability_365, trainning_data$price, method="pearson") #P-value = 3.779e-08
# all quantitative variables have P-value < alpha = 0.05, Therefore, we can reject H0 and accept Ha.
# we can say that they have "linear relationship" between X and Y.

# check multicollinearity on quantitative data in training dataset
# select only numeric features
trainning_numVars <- which(sapply(trainning_data, is.numeric)) # isolate the numeric variables
trainning_numVars_all <- trainning_data[, trainning_numVars] #construct all frame

trainning_numVars_all.cor = cor(trainning_numVars_all, method = c("pearson"))
trainning_numVars_all.cor
corrplot(cor = trainning_numVars_all.cor)

# Linear Regression Model Building Process
# Select all features
model0 = lm(price ~ ., data = trainning_data)
summary(model0)
#par(mfrow=c(2,2)) 
#plot(model1)


#===================================================================
# 7. Variable selection
#===================================================================

null_model =lm(price ~ 1, data = trainning_data)
full_model =lm(price ~., data = trainning_data)

#Forward
model1 = step(null_model,scope=list(lower=null_model,upper=full_model),direction="forward")
summary(model1)

#Backward
midel2 = step(full_model,data=df.house,direction="backward")
summary(midel2)

#Stepwise using BIC (direction : both)
model3 = step(full_model, direction="both", data = trainning_data)
summary(model3)

# Remove reviews_per_month feature
model4 = lm(price ~ .-reviews_per_month, data = trainning_data)
summary(model4)

# Remove host_listings_count feature
model5 = lm(price ~ .-host_listings_count, data = trainning_data)
summary(model5)

# Select only quantitative features
model6 = lm(price~latitude+longitude+min_nights+number_of_reviews+reviews_per_month+host_listings_count+availability_365,
            data = trainning_data)
summary(model6)

# Select only quantitative features except number_of_reviews feature
model7 = lm(price~latitude+longitude+min_nights+reviews_per_month+host_listings_count+availability_365,
            data = trainning_data)
summary(model7)

# Choosing the best model > model0
summary_model0 <- summary(model0)
mse_0 <- summary_model0$sigma^2
r_sq_0 <- summary_model0$r.squared
adj_r_sq_0 <- summary_model0$adj.r.squared
summary_model0

abline(model1,col="blue")
predict(model1)
model1$fitted.values
model1$residuals
resd = summary(model1)$res
hist(resd)
qqnorm(resd, pch = 19, frame = FALSE)
qqline(resd, col = "blue", lwd = 2)

#===================================================================
# 8. Predicting the airbnb_test dataset using model0
#===================================================================

# pred is a vector that contains predicted values for test set.
pred <- predict(object = model0, newdata = testing_data)
pred_test = data.frame(acctual_price = testing_data$price,
                       pred_price = pred)
head(pred_test)


#===================================================================
# 9. Model checking
#===================================================================

# Residual
resid_panel(model0)
resid_xpanel(model0)

# Error -->should be normal
test_error = pred_test$acctual_price - pred_test$pred_price
hist(test_error)

# MSE: Mean of Squared Errors
mse_test = mean(test_error**2)
mse_test

# SSE: Sum of Squared Errors
sse_test = sum(test_error**2)
sse_test

# SSR: Sum of Squares Regression
ssr_test = sum((pred_test$pred_price - mean(pred_test$acctual_price))**2)
ssr_test

# R square
R2 = 1-sse_test/(sse_test+ssr_test)
R2

# RMSE: Root of Mean of Squared Errors
rmse_test = sqrt(mse_test)
rmse_test
