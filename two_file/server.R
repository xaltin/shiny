library(shiny)

mpgData <- mtcars
mpgData$am <- factor(mpgData$am, labels = c("Automatic", "Manual"))

shinyServer(function(input, output) {
  # 1
  output$distPlot <- renderPlot({
    x    <- faithful$waiting
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    hist(x, breaks = bins, col = "#75AADB", border = "white",
         xlab = "Waiting time to next eruption (in mins)",
         main = "Histogram of waiting times")
  })
  
  # 2
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
  
  # 3
  formulaText <- reactive({
    paste("mpg ~", input$variable)
  })
  output$caption2 <- renderText({
    formulaText()
  })
  output$mpgPlot <- renderPlot({
    boxplot(as.formula(formulaText()),
            data = mpgData,
            outline = input$outliers,
            col = "#75AADB", pch = 19)
  })
  
  # 4
  callModule(counter, "counter1")
})
