# Required Libraries
library(shiny)
library(ggplot2)
library(pROC)
library(caret)
library(broom)
library(dplyr)

# Load dataset and preprocess it (make sure this part is separate from the UI and server logic)
df <- read.csv("diabetic_data.csv")
str(df)

# Data Preprocessing
df <- subset(df, select = -c(patient_nbr, encounter_id, weight, payer_code, medical_specialty, examide, citoglipton, troglitazone))
numeric_cols <- c("time_in_hospital", "num_lab_procedures", "num_procedures", "num_medications", "number_outpatient", "number_emergency", "number_inpatient", "number_diagnoses")
factors_cols <- setdiff(names(df), numeric_cols)
df[numeric_cols] <- lapply(df[, numeric_cols], as.numeric)
df[factors_cols] <- lapply(df[factors_cols], as.factor)

df$age <- factor(df$age, levels = c("[0-10)", "[10-20)", "[20-30)", "[30-40)", "[40-50)", "[50-60)", "[60-70)", "[70-80)", "[80-90)", "[90-100)"), ordered = TRUE)

df$readmit_binary <- ifelse(df$readmitted == "<30", 1, 0)

set.seed(41)
splitdf <- caret::createDataPartition(df$readmitted, p = 0.8, list = FALSE)
train <- df[splitdf, ]
test <- df[-splitdf, ]

train$readmit_binary <- ifelse(train$readmitted == "<30", 1, 0)
test$readmit_binary <- ifelse(test$readmitted == "<30", 1, 0)

# Fit the Logistic Regression Model
model <- glm(
  readmitted ~ ., 
  data = train,
  family = binomial(),
  control = glm.control(maxit = 100, epsilon = 1e-8),
  na.action = na.omit
)

# Prepare coefficients for Odds Ratio Plot
coef_data <- tidy(model) %>%
  filter(!is.na(estimate), is.finite(estimate), p.value < 0.05) %>%
  mutate(odds_ratio = exp(estimate))

# Predictions and ROC Curve
pred_probs <- predict(model, newdata = test, type = "response")
test_actual_class <- test$readmit_binary
roc_obj <- roc(test_actual_class, pred_probs)
auc_val <- auc(roc_obj)

# Shiny App UI
ui <- fluidPage(
  titlePanel("Logistic Regression Dashboard"),
  sidebarLayout(
    sidebarPanel(
      h3("Model Insights"),
      p("Explore different aspects of the logistic regression model."),
      selectInput("selected_model", "Choose Analysis Type:", choices = c("Odds Ratios", "ROC Curve", "Confusion Matrix","AUC")),
    ),
    mainPanel(
      tabsetPanel(
        id = "selected_model",
        tabPanel("Odds Ratios", plotOutput("coefPlot")),
        tabPanel("ROC Curve", plotOutput("rocPlot")),
        tabPanel("AUC", verbatimTextOutput("aucText")),
        tabPanel("Confusion Matrix", plotOutput("cmPlot")),
      )
    )
  )
)

# Server Logic
server <- function(input, output) {
  
  # Render the Odds Ratio Plot
  output$coefPlot <- renderPlot({
    ggplot(coef_data, aes(x = reorder(term, odds_ratio), y = odds_ratio)) +
      geom_col(fill = "steelblue") +
      coord_flip() +
      labs(title = "Significant Logistic Regression Odds Ratios", x = "Predictors", y = "Odds Ratio") +
      geom_hline(yintercept = 1, linetype = "dashed", color = "red")
  })
  
  # Render ROC Curve
  output$rocPlot <- renderPlot({
    plot(roc_obj, col = "darkgreen", lwd = 2, main = "ROC Curve - Logistic Regression")
    abline(a = 0, b = 1, col = "gray", lty = 2)
    legend("bottomright", legend = paste("AUC =", round(auc_val, 3)), col = "darkgreen", lwd = 2)
  })
  
  # Show AUC Value
  output$aucText <- renderPrint({
    paste("AUC:", round(auc_val, 4))
  })
  
  # Confusion Matrix Plot
  output$cmPlot <- renderPlot({
    test_pred_class <- ifelse(pred_probs > 0.5, 1, 0)
    cm <- confusionMatrix(factor(test_pred_class, levels = c(0, 1)), factor(test_actual_class, levels = c(0, 1)), positive = "1")
    
    cm_table <- as.data.frame(cm$table)
    names(cm_table) <- c("Predicted", "Actual", "Freq")
    
    ggplot(cm_table, aes(x = Actual, y = Predicted, fill = Freq)) +
      geom_tile() +
      geom_text(aes(label = Freq), color = "white", size = 6) +
      scale_fill_gradient(low = "lightblue", high = "darkblue") +
      labs(title = "Confusion Matrix", x = "Actual", y = "Predicted") +
      theme_minimal()
  })
}

# Run the app
shinyApp(ui = ui, server = server)
