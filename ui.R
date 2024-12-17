library(shiny)

shinyUI(fluidPage(
  titlePanel("Heart Disease Analysis - Interactive Shiny App"),
  
  sidebarLayout(
    sidebarPanel(
      h4("Data Exploration"),
      selectInput("exp_var", "Select Variable for Exploration:",
                  choices = c("Age" = "age", 
                              "Resting BP" = "trestbps", 
                              "Cholesterol" = "chol", 
                              "Oldpeak" = "oldpeak")),
      
      h4("Data Analysis"),
      selectInput("x_var", "Select X-axis Variable:", 
                  choices = c("Age" = "age", "Resting BP" = "trestbps", "Cholesterol" = "chol")),
      selectInput("y_var", "Select Y-axis Variable:",
                  choices = c("Oldpeak" = "oldpeak", "Cholesterol" = "chol", "Resting BP" = "trestbps")),
      
      selectizeInput("ml_vars", "Select Predictors for Machine Learning:",
                     choices = c("Age" = "age", "Sex" = "sex", "Resting BP" = "log_trestbps", "Cholesterol" = "log_chol"),
                     selected = c("age", "sex"), multiple = TRUE),
      actionButton("run_models", "Run Models")
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Data Summary", 
                 verbatimTextOutput("data_summary"),
                 tableOutput("missing_data"),
                 plotOutput("summary_plot")),
        
        tabPanel("Data Exploration", 
                 plotOutput("distribution_plot"),
                 plotOutput("box_plot")),
        
        tabPanel("Visualizations", 
                 plotOutput("scatter_plot")),
        
        tabPanel("Model Evaluation", 
                 verbatimTextOutput("logistic_summary"),
                 verbatimTextOutput("rf_summary"),
                 plotOutput("roc_curve"))
      )
    )
  )
))
