# Neural Network Builder 
# Also test accuracy at end
# THIS CODE ADAPTED FROM ANALYTICS VIDHYA

# IF YOU GET CBIND ERROR number of rows of result not multiple of vector length...
# Means there are NA's in the column trying to built neural off of, subset for when columns NOT NA

library(dplyr)
library(caret)

# Read the Data, filter if needed to get rid of outlier or NA cases
data = ML_frame

# Creating same data subset
samplesize = 0.3 * nrow(data)

# Random sampling
set.seed(80)

# Index variable
index = sample( seq_len ( nrow ( data ) ), size = samplesize )

# Create training and test set
datatrain = data[ index, ]
datatest = data[ -index, ]

## Scale data for neural network
max = apply(data , 2 , max)
min = apply(data, 2 , min)

#scaled = as.data.frame(scale(data, center = min, scale = max - min))
preproc <- preProcess(data, method=c("center", "scale"))
scaled <- predict(preproc, data)

# load neuralnet
library(neuralnet)

# Create training and test set (SCALED)
trainNN = scaled[index , ]
testNN = scaled[-index , ]

# Fit neural network
# Choose characteristics
set.seed(2)
NN = neuralnet(formula <- multiple_removals ~ 
                            zip + zip_count + number_participants +
                            case_duration_yrs + number_caregivers +
                            age_child + avg_age_caregiver +
                            avg_gross_income_zip,
                          trainNN, hidden=c(7,2) , linear.output = FALSE )

# plot neural network
plot(NN)


results <- data.frame(actual = trainNN$multiple_removals, prediction = NN$net.result)

predicted=results[,2] * abs(diff(range(trainNN$multiple_removals))) + min(trainNN$multiple_removals)
actual = results$actual * abs(diff(range(unlist(NN$net.result)))) + min(unlist(NN$net.result))
comparison=data.frame(predicted,actual)
deviation=((actual-predicted)/actual)
comparison=data.frame(predicted,actual,deviation)
accuracy=1-abs(mean(deviation))
accuracy

# ==================================================================
## Prediction using neural network

# Select indices of rows (manually enter - update this)
predict_testNN = neuralnet::compute(NN, testNN[ ,c(2,3,6,7,8,9,10,11)])

# Scale
predict_testNN = (predict_testNN$net.result * (max(data$number_removals) - min(data$number_removals))) + min(data$number_removals)

# Plot result
plot(datatest$number_removals, predict_testNN, col='blue', pch=16, ylab = "NN's Predicted Result", xlab = "Real Result", main="Neural Network Accuracy")

# Plot what perfect result would look like
abline(0,1)

# Calculate Root Mean Square Error (RMSE)
# RMSE.NN = (sum((datatest$Weight - predict_testNN)^2) / nrow(datatest)) ^ 0.5
# print(RMSE.NN)

# Want to test one set of values?
# Testing - incomplete
# neuralnet::compute(NN, testNN[1 ,c(3,6,7,9,10,11,12,13)])$net.result * (max(data$Weight) - min(data$Weight)) + min(data$Weight)

# remove(predict_testNN,index,max,min,datatrain,datatest,NN,testNN,trainNN,samplesize,RMSE.NN,data,scaled)
