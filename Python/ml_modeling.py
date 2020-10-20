# -*- coding: utf-8 -*-
"""
Created on Mon Oct 19 12:48:59 2020

@author: mathemacode

Machine learning modeling of ERAU PSF data after
feature engineering done to create "ML_frame.csv".

Data file built in ./R/all_numbers_merge_data.R

"""

import pandas as pd
import shap
import eli5
import os
from eli5.sklearn import PermutationImportance
from sklearn.ensemble import RandomForestRegressor
import xgboost as xgb
from sklearn.ensemble import RandomForestClassifier
from sklearn import preprocessing
from sklearn.metrics import mean_absolute_error
from sklearn.model_selection import train_test_split
from sklearn.neural_network import MLPClassifier
from sklearn.datasets import make_classification
from xgboost import XGBRegressor


os.getcwd()
os.chdir("C:\\Users\\dell\\Documents\\GitHub\\PSF_ERAU")

# Import data
df = pd.read_csv('./data/ml/ML_frame.csv')
#df.head()


# Normalize df
min_max_scaler = preprocessing.MinMaxScaler()
np_scaled = min_max_scaler.fit_transform(df)
df_norm = pd.DataFrame(np_scaled)

df_norm.columns = df.columns
df_norm.head()

details = df.describe()
details_nocount = details.iloc[1:]
#details

#============================================================================#

# Use these rows for prediction:
features = ['zip', 'zip_count', 'number_participants',
            'case_duration_yrs', 'number_caregivers',
            'age_child', 'avg_age_caregiver',
            'avg_gross_income_zip', 'first_placement']
X = df_norm[features]

# What to predict:
y = df_norm.multiple_removals

# Train/test split
train_X, val_X, train_y, val_y = train_test_split(X, y, random_state = 0)


# ============================================================================#
# Random Forest
rf_model = RandomForestClassifier(random_state=1)
rf_model.fit(train_X, train_y)

rf_predictions = rf_model.predict(val_X)
print("\nRandom Forest Mean Absolute Error: \n", 
      mean_absolute_error(val_y, rf_predictions))

perm = PermutationImportance(rf_model, random_state=1).fit(val_X, val_y)
eli5.show_weights(perm, feature_names = val_X.columns.tolist())


#============================================================================#
# XGBoost
xg_model = xgb.XGBClassifier(n_estimators=500, learning_rate=0.05)
xg_model.fit(train_X, train_y,
             early_stopping_rounds=5, 
             eval_set=[(val_X, val_y)], 
             verbose=False)

xg_predictions = xg_model.predict(val_X)
print("\nXGBoost Mean Absolute Error: \n",
      str(mean_absolute_error(xg_predictions, val_y)))

perm = PermutationImportance(xg_model, random_state=1).fit(val_X, val_y)
eli5.show_weights(perm, feature_names = val_X.columns.tolist())


#============================================================================#
# Neural Network
X, y = make_classification(n_samples=200, random_state=1)

NN = MLPClassifier(random_state=1, max_iter=2000).fit(train_X, train_y)

NN_predictions = NN.predict(val_X)
print("\nNeural Network Mean Absolute Error: \n",
      str(mean_absolute_error(NN_predictions, val_y)))

# regr.score(val_X, val_y)
#regr.predict(val_X[:3])

perm = PermutationImportance(NN, random_state=1).fit(val_X, val_y)
eli5.show_weights(perm, feature_names = val_X.columns.tolist())


#============================================================================#

# SHAP values
row_to_show = 1
data_for_prediction = val_X.iloc[row_to_show]  # use 1 row of data here. Could use multiple rows if desired
data_for_prediction_array = data_for_prediction.values.reshape(1, -1)

rf_model.predict_proba(data_for_prediction_array)

# Create object that can calculate shap values
explainer = shap.TreeExplainer(rf_model)

# Calculate Shap values
shap_values = explainer.shap_values(data_for_prediction)

# Error below for some reason?
# shap.summary_plot(shap_values, X, plot_type = 'bar')

shap.initjs()
shap.force_plot(explainer.expected_value[1], shap_values[1], data_for_prediction)

