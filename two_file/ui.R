library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  titlePanel("Hello Shiny!"),
  sidebarLayout(
    sidebarPanel(
      # 1
      sliderInput(inputId = "bins",
                  label = "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30),
      
      # 2
      textInput(inputId = "caption",
                label = "Caption:",
                value = "Data Summary"),
      selectInput(inputId = "dataset",
                  label = "Choose a dataset:",
                  choices = c("rock", "pressure", "cars")),
      numericInput(inputId = "obs",
                   label = "Number of observations to view:",
                   value = 10),
      
      # 3
      selectInput("variable", "Variable:", 
                  c("Cylinders" = "cyl",
                    "Transmission" = "am",
                    "Gears" = "gear")),
      checkboxInput("outliers", "Show outliers", TRUE),
      
      # 4
      counterButton("counter1", "Counter #1")
    ),
    mainPanel(
      # 1
      plotOutput(outputId = "distPlot"),
      
      # 2
      h3(textOutput("caption", container = span)),
      verbatimTextOutput("summary"),
      tableOutput("view"),
      
      # 3
      h3(textOutput("caption2")),
      plotOutput("mpgPlot")
    )
  )
))
