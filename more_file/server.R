library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    callModule(counter, "counter1")
})
