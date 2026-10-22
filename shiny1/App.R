
library(shiny)

ui <- fluidPage(
  titlePanel("Ma premiere application Shiny"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput(
        inputId = "alpha",
        label = "Mélange exponentiel",
        min = 0.01,
        max = 1,
        value = .5
      ),
      sliderInput(
        inputId = "lambda",
        label = "Parametre de lissage",
        min = 0.01,
        max = 10,
        value = 1
      ),
      sliderInput(
        inputId = "sigma",
        label = "Ecart-type",
        min = 0.01,
        max = 10,
        value = 1
      )
    ),
    
    mainPanel(
      plotOutput("courbe"),
      textOutput("valeur")
    )
  )
)

server <- function(input, output, session) {
  
  output$courbe <- renderPlot({
    x <- seq(0, 10, length.out = 200)
    eps=rnorm(length(x))
    sigma=input$sigma
    ystar <- (1-input$alpha)*sin(2*x) + input$alpha*exp(x-9)
    y=ystar+eps*sigma
    
    plot(range(x), range(ystar)+2*sigma*c(-1,1), type = "n",
         main = "Effet du parametre",
         xlab = "Temps",
         ylab = "Estimation")
    lines(x, ystar, type = "l",
         main = "Effet du parametre",
         xlab = "Temps",
         ylab = "Estimation")
    points(x, y,col=2)
    lines(smooth.spline(x = x,y=y,df = input$lambda ),col="blue")
  })
  
  output$valeur <- renderText({
    paste("Lambda =", input$lambda)
  })
}

shinyApp(ui = ui, server = server)

