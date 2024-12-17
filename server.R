library(shiny)
library(ggplot2)
library(dplyr)
library(caret)
library(pROC)
library(randomForest)

shinyServer(function(input, output) {
  # Load and Preprocess Data
  heart_data <- read.csv("processed.cleveland.data", header = FALSE, na.strings = "?")
  colnames(heart_data) <- c("age", "sex", "cp", "trestbps", "chol", "fbs", "restecg", 
                            "thalach", "exang", "oldpeak", "slope", "ca", "thal", "target")
  heart_data$log_oldpeak <- log(heart_data$oldpeak + 0.1)
  heart_data$log_trestbps <- log(heart_data$trestbps)
  heart_data$log_chol <- log(heart_data$chol)
  heart_data$target <- as.factor(ifelse(heart_data$target > 0, 1, 0))  # Binary target
  
  # Data Summary
  output$data_summary <- renderPrint({
    summary(heart_data)
  })
  
  output$missing_data <- renderTable({
    data.frame(Feature = names(heart_data), Missing_Values = colSums(is.na(heart_data)))
  })
  
  # Data Summary Plot
  output$summary_plot <- renderPlot({
    ggplot(heart_data, aes(x = factor(target))) +
      geom_bar(fill = "skyblue", color = "black") +
      labs(title = "Distribution of Target Variable", x = "Target", y = "Count")
  })
  
  # Data Exploration
  output$distribution_plot <- renderPlot({
    ggplot(heart_data, aes_string(x = input$exp_var)) +
      geom_histogram(fill = "blue", bins = 20, color = "black", alpha = 0.7) +
      labs(title = paste("Distribution of", input$exp_var), x = input$exp_var, y = "Count")
  })
  
  output$box_plot <- renderPlot({
    ggplot(heart_data, aes_string(y = input$exp_var, x = "target", fill = "target")) +
      geom_boxplot() +
      labs(title = paste("Boxplot of", input$exp_var, "by Target"), x = "Target", y = input$exp_var)
  })
  
  # Visualizations
  output$scatter_plot <- renderPlot({
    ggplot(heart_data, aes_string(x = input$x_var, y = input$y_var, color = "target")) +
      geom_point(alpha = 0.7) +
      labs(title = paste("Scatter Plot of", input$x_var, "vs", input$y_var))
  })
  
  # Machine Learning Models
  models <- reactive({
    input$run_models
    isolate({
      predictors <- input$ml_vars
      logistic_data <- heart_data[, c(predictors, "target")]
      logistic_data <- na.omit(logistic_data)
      
      # Train-Test Split
      set.seed(123)
      train_index <- createDataPartition(logistic_data$target, p = 0.7, list = FALSE)
      train_data <- logistic_data[train_index, ]
      test_data <- logistic_data[-train_index, ]
      
      # Logistic Regression
      logistic_model <- glm(target ~ ., data = train_data, family = "binomial")
      logistic_pred <- predict(logistic_model, test_data, type = "response")
      logistic_auc <- auc(test_data$target, logistic_pred)
      
      # Random Forest
      rf_model <- randomForest(target ~ ., data = train_data, ntree = 100)
      rf_pred <- predict(rf_model, test_data, type = "prob")[, 2]
      rf_auc <- auc(test_data$target, rf_pred)
      
      list(logistic_model = logistic_model, logistic_auc = logistic_auc,
           rf_model = rf_model, rf_auc = rf_auc,
           test_data = test_data, logistic_pred = logistic_pred, rf_pred = rf_pred)
    })
  })
  
  output$logistic_summary <- renderPrint({
    summary(models()$logistic_model)
  })
  
  output$rf_summary <- renderPrint({
    paste("Random Forest AUC:", round(models()$rf_auc, 3))
  })
  
  output$roc_curve <- renderPlot({
    test_data <- models()$test_data
    logistic_pred <- models()$logistic_pred
    rf_pred <- models()$rf_pred
    
    roc_logistic <- roc(test_data$target, logistic_pred)
    roc_rf <- roc(test_data$target, rf_pred)
    
    plot(roc_logistic, col = "blue", main = "ROC Curve Comparison")
    plot(roc_rf, col = "red", add = TRUE)
    legend("bottomright", legend = c("Logistic Regression", "Random Forest"), 
           col = c("blue", "red"), lwd = 2)
  })
})
