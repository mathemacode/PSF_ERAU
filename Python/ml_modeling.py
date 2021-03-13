# -*- coding: utf-8 -*-
"""
Classification predictions of ERAU PSF data after
feature engineering done to create "ML_frame.csv".

Data file built in ./R/all_numbers_merge_data.R

This program includes a Random Forest model for classification: 
either 0 - no expectation of multiple removals, or 1 - expected
to be removed more than once.

"""

import eli5
import pandas as pd
import shap
import os
import pickle
import xgboost as xgb
from eli5.sklearn import PermutationImportance
from matplotlib import pyplot as plt
from sklearn.ensemble import RandomForestClassifier
from sklearn import metrics, preprocessing
from sklearn.model_selection import train_test_split
from sklearn.datasets import make_classification

os.getcwd()
os.chdir("C:\\Users\\dell_\\Documents\\GitHub\\PSF_ERAU")

# Import data
df = pd.read_csv('./data/ml/ML_frame.csv')

# df.head()

# ============================================================= #

details = df.describe()
details_nocount = details.iloc[1:]
details

# ============================================================= #

# Use these rows for prediction:
features = ['zip_count', 'number_participants',
            'case_duration_yrs', 'number_caregivers',
            'age_child', 'avg_age_caregiver',
            'med_gross_income_zip', 'first_placement',
            'gender', 'ethnicity', 'perc_life',
            'first_place_duration']
X = df[features]

# What to predict:
# this column is only 0's and 1's: 0 means no additional removals past initial removal, 1 means multiple removals
y = df.multiple_removals

# Train/test split
train_X, val_X, train_y, val_y = train_test_split(X, y, random_state = 0)

# ============================================================= #


# Determine best parameters for RandomForest Model
result = [[],[],[]]

for depth in range(8, 64, 8):
    for n_est in range(25, 500, 25):
        rf_model = RandomForestClassifier(random_state=1, max_depth=depth, n_estimators=n_est)
        rf_model.fit(train_X, train_y)
        rf_predictions = rf_model.predict(val_X)
        res = (metrics.accuracy_score(val_y, rf_predictions, sample_weight=None)*100)
        
        result[0].append(depth)
        result[1].append(n_est)
        result[2].append(res)
        
max_acc = max(result[2])
ind = result[2].index(max_acc)

print("Best model params: max_depth={}, n_estimators={}, with accuracy {}%".format(result[0][ind], 
                                                                                   result[1][ind], result[2][ind]))
print("These are automatically entered into model below.")

best_depth = result[0][ind]
best_n = result[1][ind]

# ============================================================= #

# Random Forest
rf_model = RandomForestClassifier(random_state=1, max_depth=best_depth, n_estimators=best_n)
rf_model.fit(train_X, train_y)

rf_predictions = rf_model.predict(val_X)
print("\nRandom Forest Mean Accuracy:\n {:.2f}% \n".format(( 
      metrics.accuracy_score(val_y, rf_predictions, sample_weight=None)*100)))

mat = metrics.confusion_matrix(val_y, rf_predictions)
print("\nConfusion Matrix:\n", mat)

class_report = metrics.classification_report(val_y, rf_predictions)
print("\nClassification Report:\n",class_report)

perm = PermutationImportance(rf_model, random_state=1).fit(val_X, val_y)
eli5.show_weights(perm, feature_names = val_X.columns.tolist())


# ============================================================= #

# RANDOM FOREST
# SHAP values

# Row for SHAP analysis
# 11 is good example, 80, 82, 117, 119, 120
row_to_show = 82

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

# ============================================================= #

# Pickle the RF model to save for app

# Save to file in the current working directory
pkl_filename = "./Python/saved_rf_model.pkl"
with open(pkl_filename, 'wb') as file:
    pickle.dump(rf_model, file)
    
# ============================================================= #

# XGBoost
xg_model = xgb.XGBClassifier(n_estimators=500, learning_rate=0.05)
xg_model.fit(train_X, train_y,
             early_stopping_rounds=5, 
             eval_set=[(val_X, val_y)], 
             verbose=False)

xg_predictions = xg_model.predict(val_X)
print("\nXGBoost Mean Accuracy:\n {:.2f}% \n".format(( 
      metrics.accuracy_score(val_y, xg_predictions, sample_weight=None)*100)))

mat = metrics.confusion_matrix(val_y, xg_predictions)
print("\nConfusion Matrix:\n", mat)

class_report = metrics.classification_report(val_y, xg_predictions)
print("\nClassification Report:\n",class_report)

perm = PermutationImportance(xg_model, random_state=1).fit(val_X, val_y)
eli5.show_weights(perm, feature_names = val_X.columns.tolist())







