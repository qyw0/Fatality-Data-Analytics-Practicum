#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
#==========================Instructions======================================
# Please Run "0-occurring_interactive.R" before running this Shiny app
# Use the search box to select code
# Size of each nodes indicates overall frequency of this code in past ten years
# Thickness of each degree indicates co-ocurring frequency of this pair

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("How one code interact with other codes"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
        
         selectizeInput("icd",
                     "Select an ICD10 Code:",
                     choice = s3,
                     selected = "I250",
                     multiple=F),
         width = 3
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("net",width = 500, height = 500),
         textOutput("value")
         
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

  code1 <- renderText({ input$icd })
  
  output$net <- renderPlot({
     
     
     networkplot(code1()[1])
 })
     

    }

# Run the application 
shinyApp(ui = ui, server = server)

