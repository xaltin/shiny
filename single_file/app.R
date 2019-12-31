library(shiny)


# -------------------------------------------------------------------------
ui <- fluidPage(
  titlePanel("Hello Shiny!"),
  sidebarLayout(
    sidebarPanel(
      sliderInput(inputId = "bins",
                  label = "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30),
      textInput(inputId = "caption",
                label = "Caption:",
                value = "Data Summary"),
      selectInput(inputId = "dataset",
                  label = "Choose a dataset:",
                  choices = c("rock", "pressure", "cars")),
      numericInput(inputId = "obs",
                   label = "Number of observations to view:",
                   value = 10)
    ),
    mainPanel(
      plotOutput(outputId = "distPlot"),
      h3(textOutput("caption", container = span)),
      verbatimTextOutput("summary"),
      tableOutput("view")
    )
  )
)

server <- function(input, output) {
  output$distPlot <- renderPlot({
    x    <- faithful$waiting
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    hist(x, breaks = bins, col = "#75AADB", border = "white",
         xlab = "Waiting time to next eruption (in mins)",
         main = "Histogram of waiting times")
  })
  datasetInput <- reactive({
    switch(input$dataset,
           "rock" = rock,
           "pressure" = pressure,
           "cars" = cars)
  })
  output$caption <- renderText({
    input$caption
  })
  output$summary <- renderPrint({
    dataset <- datasetInput()
    summary(dataset)
  })
  output$view <- renderTable({
    head(datasetInput(), n = input$obs)
  })
}

shinyApp(ui = ui, server = server)


# -------------------------------------------------------------------------
ui <- pageWithSidebar(
  headerPanel("Miles Per Gallon"),
  sidebarPanel(
    selectInput("variable", "Variable:", 
                c("Cylinders" = "cyl",
                  "Transmission" = "am",
                  "Gears" = "gear")),
    checkboxInput("outliers", "Show outliers", TRUE)
  ),
  mainPanel(
    h3(textOutput("caption")),
    
    plotOutput("mpgPlot")
  )
)

mpgData <- mtcars
mpgData$am <- factor(mpgData$am, labels = c("Automatic", "Manual"))

server <- function(input, output) {
  formulaText <- reactive({
    paste("mpg ~", input$variable)
  })
  output$caption <- renderText({
    formulaText()
  })
  output$mpgPlot <- renderPlot({
    boxplot(as.formula(formulaText()),
            data = mpgData,
            outline = input$outliers,
            col = "#75AADB", pch = 19)
  })
}

shinyApp(ui, server)


# -------------------------------------------------------------------------
counterButton <- function(id, label = "Counter") {
  ns <- NS(id)
  tagList(
    actionButton(ns("button"), label = label),
    verbatimTextOutput(ns("out"))
  )
}

counter <- function(input, output, session) {
  count <- reactiveVal(0)
  observeEvent(input$button, {
    count(count() + 1)
  })
  output$out <- renderText({
    count()
  })
  count
}

ui <- fluidPage(
  counterButton("counter1", "Counter #1")
)

server <- function(input, output, session) {
  callModule(counter, "counter1")
}

shinyApp(ui, server)









































