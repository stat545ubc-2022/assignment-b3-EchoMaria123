library(shiny)
library(colourpicker)
library(ggplot2)
library(dplyr)

bcl <- read.csv("bcl-data.csv", stringsAsFactors = FALSE)

#Features added:
# Feature 1: add a logo image,this will make the user interface more appealing
# Feature 2: add color parameter to the plot to let the user decide on the colour of the bars in the plot, which could be used to differentiate different plots, 
#set as black by default.
# Feature 3: place plot and table in separate tabs so that the layout looks more organized and concise 
# Feature 4: Show the number of results found whenever the filters change, which gives the user a direct numeric reflection of the number of results returned based on the filters chosen.
ui <- fluidPage(
  br(),
  # Feature1: add a logo image
  img(src = "logo.png"),
  titlePanel("BC Liquor Store prices"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("priceInput", "Price", min = 0, max = 100,
                  value = c(25, 40), pre = "$"),
      radioButtons("typeInput", "Product type",
                   choices = c("BEER", "REFRESHMENT", "SPIRITS", "WINE"),
                   selected = "WINE"),
      uiOutput("countryOutput"),
      # Feature 2: add color parameter, set as black by default.
      colourInput("colorChosen", "Plot Bar Color", "Black") 
    ),
    mainPanel(
      # Feature 3: place plot and table in separate tabs
      tabsetPanel(
        tabPanel("Plot", plotOutput("coolplot")),
        tabPanel("Table", textOutput("numOfResults"),tableOutput("results"))# Feature 4: Show the number of results found whenever the filters change
      )
    )
  )
)

server <- function(input, output) {
  output$countryOutput <- renderUI({
    selectInput("countryInput", "Country",
                sort(unique(bcl$Country)),
                selected = "CANADA")
  })  
  
  filtered <- reactive({
    if (is.null(input$countryInput)) {
      return(NULL)
    }    
    
    bcl %>%
      filter(Price >= input$priceInput[1],
             Price <= input$priceInput[2],
             Type == input$typeInput,
             Country == input$countryInput
      )
  })
  
  output$coolplot <- renderPlot({
    if (is.null(filtered())) {
      return()
    }
    #Feature 3: let the user decide on the colour of the bars in the plot
    ggplot(filtered(), aes(Alcohol_Content)) +
      geom_histogram(fill = input$colorChosen)
  })
  
  output$results <- renderTable({
    filtered()
  })
  
  # Feature 4: show number of results when filters change
  output$numOfResults <- renderText({
    paste(nrow(filtered())," results were found based on the filter you selected")
  }) 
  
}

shinyApp(ui = ui, server = server)