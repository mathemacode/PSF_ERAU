# PSF ERAU Foster Care Project
 More ML modeling of PSF data, and development of an app for child risk predictions based on case data.
 
 This is a continuation of the PSF project documented in
 [the FosterCare_Proj repository](https://github.com/mathemacode/FosterCare_Project).
 
 After working with the data a lot I decided to take a more narrowed approach in building 
 a classification model to predict "circular" cases of more than 1 removal.  This would mean that 
 the child had been removed multiple times, as opposed to cases that simply have a number of 
 placements (foster home to group home and back, or other).  When originally working with the company 
 that provided this data, one of the objectives of the research of data scientists was to predict
 these removals.  In this repo I have redone the ingestion (with new data for 2019), and am working 
 on building accurate classification models that can predict if a child will have more than 1 removal.
 I also want to document this well for future data scientists who want to take on this problem.
 
 # Machine Learning Models
 **Overall goal**: a program to enter in case details and output a prediction.  A very basic design is 
 [at this link](https://www.kaggle.com/daniielo/foster-calculator).
 
 There is now an easy way to start building ML models using [this notebook](./Python/ml_modeling.ipynb)), 
 which uses the dataframe output by [this R program](./R/all_numbers_merge_data.R).  **This is not the same 
 file in the original repo despite the name!  It has been heavily modified.**  I also decided to use 
 [2018 IRS data](https://www.irs.gov/statistics/soi-tax-stats-individual-income-tax-statistics-2018-zip-code-data-soi) 
 to add on an `avg_gross_income_zip` as a feature to model.  In the original project work, I did 
 add in some economic information into the models.  This IRS dataset with ZIP code granularity appeared 
 useful for this analysis.
 
 The Random Forest model that the above notebook creates is saved to a pickle file.  That file can then be 
 imported and used for future predictions, which is what I am currently developing - an easy system to do this.

 ## Raw data to model-building steps
 1. Manually check `.xlsx` files, edit yearly files of same type to have same number of columns (even if blank)
 2. Add column (manual or R) to Participants, Removals, and Placements for indexes used as Primary Key (only relevant for DB)
 3. Run `combine_export_cases.R` first, then the other three `combine_export______.R` files
 4. Run `all_numbers_merge_data.R`, which outputs the file `ML_frame.csv` into ./data/ml (hidden on this repo)
 5. Open `./Python/ml_modeling.ipynb` for some pre-built models (currently Random Forest & XGBoost)
 
 If desired, use `df_PK_test.R` to verify that the PK column of a dataframe in R is, in fact, unique, and
 suitable to be used as a PK for unique identification of a case and/pr it's details.  If it's not unique, 
 a `duplicates` table is available for debugging.
 
 ## Model Accuracy
 So far I have achieved accuracies above 80% (overall) to classify a child as 0 (no risk of multiple removals), or
 1 (multiple removals expected).  Both the Random Forest and XGBoost can be tuned to achieve 80+%.  There is currently 
 a loop running in the Jupyter Notebook which finds the most accurate parameters for the Random Forest model. 
 Although it takes some additional time to compute, the models make the best possible predictions.
 
 ![RF_model_stats](./pics/RF_model_stats.PNG)

 
 ## Interpreting SHAP Visualizations
 I am also experimenting with SHAP values to visualize feature influences, and might try to build 
 some partial plots as well, but these so far have been fantastic to visualize why the prediction is 
 the way that it is.
 
 How it works: the probabilistic model has a baseline prediction (around 0.22 in this case) between 0 and 1,
 which is the "average" prediction.  When the model looks at the features of a case all at once, it weighs 
 certain data more than others (for example, in the green chart above, the features at the top more heavily
 influence this 0 or 1 output, whereas those at the bottom are not as influential).  These plots below with 
 red and blue are showing how each feature "pushes" the overall prediction in one direction vs. the other
 (for example, in the direction of 0 instead of 1).
 
 An example of a probabilistic prediction leaning to 0:
 ![shap1](./pics/shap_ex_1.PNG)
 
 Example of very strong evidence for no further removals:
 ![shap2](./pics/shap_ex_2.PNG)
 
 Example of very strong evidence for more than 1 removal:
 ![shap3](./pics/shap_ex_3.PNG)
 
 With an experienced practitioner in the loop, more analysis could be done to better understand the risk of each
 child.  The model can only show us which characteristics influenced the prediction the most, and how they 
 influenced this prediction.
