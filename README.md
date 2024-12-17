# Heart Disease Analysis - Shiny App

## Project Overview
This project analyzes the UCI Heart Disease dataset using interactive R Shiny dashboards. The app provides data exploration, visualizations, and machine learning predictions to identify key predictors of heart disease.

## Features
- **Data Summary**: View missing values and descriptive statistics.
- **Visualizations**:  
    - Histograms and Boxplots for variable distributions.  
    - Scatter plots to explore relationships between variables.  
- **Machine Learning Models**:  
    - Logistic Regression and Random Forest for predicting heart disease.  
    - ROC Curve comparison for model evaluation.

## Data Source
- Dataset: [UCI Heart Disease Dataset](https://archive.ics.uci.edu/ml/datasets/heart+disease)

## Tools Used
- R, Shiny, ggplot2, caret, randomForest, pROC.

## Instructions to Run the App
1. Clone this repository.
2. Open the `server.R` and `ui.R` files in RStudio.
3. Run the Shiny App using the `runApp()` function.

## Insights
- Age, Cholesterol, and Resting Blood Pressure are key predictors of heart disease.
- Random Forest outperformed Logistic Regression in prediction accuracy.

## Author
Devansh Pathak

## License
This project is for educational purposes only.
