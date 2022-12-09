library(shiny)
library(ggplot2) 
library(dplyr)
library(shinythemes)# for adding theme
library(DT) # for interactive table

bcl <- read.csv("bcl-data.csv", stringsAsFactors = FALSE)


ui <- fluidPage(
  
  # app theme
  theme = shinytheme("cerulean"),
  
  # app logo image
  img(src = "logo.png"),
  
  #app title
  titlePanel("Find your ideal drink!"),
  
  #Introduction and guidance of the app
  h4("Welcome to our BC Liquor Store app, we will make it so much easier for you ^_^"),
  h5("In our app, we aim to assit you to find your ideal drink and you can do so by choosing from a variety of fliters - Price range, Product type and Country of origin."),
  h5("We will show you the filterd results in both histograms and interactive table, you can switch between them using the tabs on the right."),
  h5("For your convenience, you can choose multiple Product type and Country of origin simultaneously and the distribution of Alchohol_Content will be generated under the Histogram tab on the right."),
  h5("Under the Interactive Table tab, you can customize the number of entries, search by key word, sort the table and download the table as a .csv file."),
  sidebarLayout(
    sidebarPanel(
      # Filters
      #price range
      sliderInput("priceInput", "Price range", min = 0, max = 100,
                  value = c(25, 40), pre = "$"),
      # allow for multiple choices in Product type
      checkboxGroupInput("typeInput", "Product type",
                   choices = c("BEER", "REFRESHMENT", "SPIRITS", "WINE"),
                   selected = "WINE"),
      #country of origin
      uiOutput("countryOutput"),
      #allow user to customize the plot bin number
      sliderInput("hisBin", "Histogram Bins", min = 10, max = 50,
                  value = 30),
    ),
    mainPanel(
      # Place plot and table in separate tabs
      tabsetPanel(
        tabPanel("Histogram", plotOutput("coolplot")),
        tabPanel("Interactice Table", 
                 br(),
                 h5(textOutput("numOfResults")),
                 br(),
                 #download table as csv
                 downloadButton("downloadTable", "Download Table"),
                 br(), br(),
                 #interactive table
                 dataTableOutput("results"),
                )
      )
    )
  )
)

server <- function(input, output) {
  output$countryOutput <- renderUI({
    selectInput("countryInput", "Country of origin",
                sort(unique(bcl$Country)),
                # allow for multiple choices in Country
                selected = "CANADA", multiple = TRUE)
  })  
  
  #reactive to filters
  filtered <- reactive({
    if (is.null(input$countryInput)) {
      return(NULL)
    }    
    
    bcl %>%
      filter(Price >= input$priceInput[1],
             Price <= input$priceInput[2],
             Type %in% input$typeInput,
             Country %in% input$countryInput
      )
  })
  

  output$coolplot <- renderPlot({
    if (is.null(filtered())) {
      return()
    }
    #separate plots from different countries and differentiate Product type by fill color
    filtered() %>% ggplot(aes(Alcohol_Content, fill = Type)) +
      geom_histogram(bins = input$hisBin) + facet_wrap(~Country) + ggtitle("Distribution of Alchohol_Content with current filters")
  })
  
  #interactive table
  output$results <- renderDataTable({
    filtered()
  })
  
  #show number of results when filters change
  output$numOfResults <- renderText({
    paste("We found ", nrow(filtered()), "results for you based on current filters")
  }) 
  
  
  #enable user to download table as .csv file
  output$downloadTable <- downloadHandler(
    filename = function() {
      paste("filteredBCLiquor", ".csv", sep = "")
    },
    content = function(file) {
      write.csv(as.data.frame(filtered()), file)
    }
  )
  
}

shinyApp(ui = ui, server = server)