options(shiny.maxRequestSize = 25*1024^2)

library(shiny)
library(readxl)
library(arules)
library(arulesViz)

ui <- fluidPage(
  titlePanel("Association Rule Mining - Online Retail"),
  
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Upload Excel File", accept = ".xlsx"),
      numericInput("supp", "Minimum Support:", value = 0.01, step = 0.01),
      numericInput("conf", "Minimum Confidence:", value = 0.5, step = 0.05),
      selectInput("plotType", "Plot Type:",
                  choices = c("Scatterplot" = "scatterplot", 
                              "Grouped" = "grouped", 
                              "Graph" = "graph")),
      actionButton("run", "Run ARM")
    ),
    
    mainPanel(
      h4("Top 10 Association Rules"),
      tableOutput("rulesTable"),
      plotOutput("rulesPlot")
    )
  )
)

server <- function(input, output) {
  observeEvent(input$run, {
    req(input$file)
    
    # Step 1: Load the Excel file
    raw <- read_excel(input$file$datapath)
    
    # Step 2: Clean the data
    
    raw <- na.omit(raw)  # Remove missing values
    
    raw <- raw[!grepl("^C", raw$InvoiceNo), ]  # Remove canceled invoices
    
    
    raw <- raw[, c("InvoiceNo", "Description")]  # Select useful columns
    
    raw$InvoiceNo <- as.factor(raw$InvoiceNo)
    raw$Description <- as.factor(raw$Description)
    
    # Step 3: Convert to transactions using split (memory efficient)
    itemList <- split(raw$Description, raw$InvoiceNo)
    transactions <- as(itemList, "transactions")
    
    # Step 4: Apply Association Rule Mining
    rules <- apriori(transactions, 
                     parameter = list(supp = input$supp, 
                                      conf = input$conf, 
                                      minlen = 2))
    
    top_rules <- head(sort(rules, by = "lift"), 10)
    
    # Step 5: Display rules
    output$rulesTable <- renderTable({
      as(top_rules, "data.frame")[, c("rules", "support", "confidence", "lift")]
    })
    
    # Step 6: Plot rules
    output$rulesPlot <- renderPlot({
      plot(top_rules, method = input$plotType, engine = ifelse(input$plotType == "graph", "igraph", "default"))
    })
  })
}

shinyApp(ui = ui, server = server)
