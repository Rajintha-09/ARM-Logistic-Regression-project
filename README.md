# Exploring Consumer Behavior and Patient Outcomes  
## A Data Mining Approach using Association Rule Mining and Logistic Regression  

**Data-driven analysis of retail transactions and healthcare patient outcomes using R, Shiny, and Machine Learning techniques**

---

## Project Overview

This project explores two real-world domains using data mining techniques:

- **Retail Analytics** using Association Rule Mining (ARM)
- **Healthcare Analytics** using Logistic Regression

The aim is to extract meaningful insights from:
- Online retail transaction data (customer purchasing behavior)
- Diabetic patient dataset (hospital readmission prediction)

ARM is used to discover product associations in retail transactions, while Logistic Regression is applied to predict whether a diabetic patient will be readmitted within 30 days.

---

## Repository Structure
```
ARM-Logistic-Regression-project/
│
├── ARM/
│ ├── ARM.R
│ └── Online Retail.xlsx
│
├── Regression Analysis/
│ ├── Regression Analysis.R
│ └── diabetic_data.csv
│
├── Technical_Report.pdf
│ 
└── README.md
```

---

## Datasets

This project uses two datasets:

### 🛒 Online Retail Dataset
- UK-based retail transaction data
- Used for Association Rule Mining
- Contains invoice-level product descriptions

### 🏥 Diabetic Readmission Dataset
- Hospital patient records
- Used for Logistic Regression modeling
- Includes patient demographics, treatments, and readmission status

---

## Key Insights

### Association Rule Mining (Retail)
- Identified frequent product combinations
- Discovered strong co-purchase patterns using support, confidence, and lift
- Supports:
  - Cross-selling strategies
  - Product bundling
  - Recommendation systems

### Logistic Regression (Healthcare)
- Predicted patient readmission risk within 30 days
- Identified key medical factors influencing readmission
- Supports:
  - Early risk detection
  - Hospital resource optimization
  - Improved patient care decisions

---

## Technologies Used

- **R Programming**
- **Shiny (Interactive ARM Dashboard)**
- **arules & arulesViz**
- **tidyverse**
- **caret / pROC (Model evaluation)**
- **Excel / CSV datasets**

---

## How to Run the Project

### Association Rule Mining (ARM)
1. Open `ARM.R` in RStudio  
2. Run the Shiny application  
3. Upload `Online Retail.xlsx`  
4. Set support and confidence values  
5. Click **Run ARM**  

### Logistic Regression Analysis
1. Open `Regression Analysis.R` in RStudio  
2. Run script step-by-step  
3. View model summary, confusion matrix, and ROC curve  

---

## Methodology Summary

### ARM Approach
- Data cleaning (remove missing values and canceled invoices)
- Transaction conversion using invoice grouping
- Apriori algorithm for rule generation
- Rule filtering using support, confidence, and lift
- Visualization using arulesViz

### Logistic Regression Approach
- Data preprocessing and feature selection
- Binary target variable creation (readmission within 30 days)
- Train-test split (80/20)
- Model training using `glm()`
- Evaluation using confusion matrix and ROC-AUC

---

## Results Summary

### Retail Domain
- Strong product association rules identified
- Helps improve marketing and sales strategies

### Healthcare Domain
- Predictive model for patient readmission
- Identifies high-risk patients for early intervention

---

## Limitations

- Missing and inconsistent data in both datasets
- ARM does not capture rare item relationships effectively
- Logistic Regression assumes linear relationships
- Class imbalance in healthcare dataset

---

## Future Improvements

- Apply advanced models (Random Forest, XGBoost)
- Use SMOTE for handling class imbalance
- Improve feature engineering
- Build recommendation system from ARM results
- Deploy interactive dashboards for both models

---

## Authors / Group Members

- Rajintha Lakshani  
- Chamali Abeysekara 
- MZM Hussein
- MN Mohamed

---

## Acknowledgements

This project was completed through collaborative effort in data preprocessing, model development, and analysis. Special appreciation to all group members for their contributions in R programming, statistical modeling, and report preparation.
