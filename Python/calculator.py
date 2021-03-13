# -*- coding: utf-8 -*-
"""
Calculator for multiple removals prediction.

"""

# ============================================================= #

import pandas as pd
import shap
import os
import pickle

os.getcwd()
os.chdir("C:\\Users\\dell_\\Documents\\GitHub\\PSF_ERAU")

# ============================================================= #

# Working with inputted data
INPUT_VALUES = pd.Series({'zip_count':                  33.0,
                            'number_participants':        27.0,
                            'case_duration_yrs':           5.56,
                            'number_caregivers':           13.0,
                            'age_child':                   0.2,
                            'avg_age_caregiver':          33.2,
                            'med_gross_income_zip':    42812.0,
                            'first_placement':             2.0,
                            'gender':                      1.0,
                            'ethnicity':                   1.0,
                            'perc_life':                   60.6,
                            'first_place_duration':        50.0})

INPUT_ARRAY = INPUT_VALUES.values.reshape(1, -1)

# ============================================================= #

# Open saved model and make prediction
with open('./Python/saved_rf_model.pkl', 'rb') as file:
    pickle_model = pickle.load(file)

prediction = pickle_model.predict(INPUT_ARRAY)

# ============================================================= #

# Output explainer plot
pickle_model.predict_proba(INPUT_ARRAY)
exp = shap.TreeExplainer(pickle_model)
shap_values = exp.shap_values(INPUT_VALUES)

shap.initjs()
shap.force_plot(exp.expected_value[1], shap_values[1], INPUT_VALUES)

# ============================================================= #
