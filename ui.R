library(shiny)
shinyUI(
    fluidPage(
        # Application title
        titlePanel("Prediction of car braking distance"),
        p("The purpose of this application is to provide a prediction of 
          the stopping distance required for a car moving at a specified
          initial speed. The provided data is from the cars dataset in R
          (see plot).
          The recorded data only goes up to speeds of 25 mph, so for an 
          understanding of the braking distance-to-speed relationship at 
          higher speeds, a simple linear regression model (distance = slope * speed + 
          intercept) based on the R cars dataset is used."),
        hr(),
        fluidRow(
            
            column(4,
                   wellPanel(
                       h3("Linear Model Calibration Panel"),
                       p("In this panel, the user can manually 
                         calibrate a linear model to predict stopping
                         distance by adjusting the slope and intercept of the red line in 
                         the plot OR push the button to automatically calibrate the model."),
                       br(),
                       numericInput('intercept','Specify intercept [ft]', value = 0, 
                                    min = -25, max = 25),
                       numericInput('slope','Specify slope [ft/mph]', value = 0, 
                                    min = 0, max = 5, step = 0.1),
                       strong("OR"),
                       br(),
                       actionButton('calibrate',"Automatically calibrate model")        
                   )       
            ),
            
            column(8,
                       h2('Linear model calibration plot', align = 'center'),
                       textOutput("autoCalibrate"),
                       tableOutput("ModelParameters"),
                       plotOutput("CarScatterPlot")
            )
            
        ),# end fluidRow
        hr(),
        fluidRow(
            column(4,
                   wellPanel(
                       h3("Prediction Panel"),
                       h4("(Based on above calibration)"),
                       p("When satisfied with the calibration, in this panel, 
                          the user can play around with car speeds to see how the 
                          calibrated model predicts car stopping 
                          distances."),
                       numericInput('inputSpeed','Enter speed [mph]', value = 15, 
                                    min = 5, max = 200, step = 5)
                   )       
            ),
            
            column(8,
                   h2('Model prediction output', align = 'center'),
                   h4('Speed specified [mph]:'),
                   verbatimTextOutput("speedInput"),
                   h4('Predicted stopping distance [ft]:'),
                   verbatimTextOutput("predictedDist")
            )
        )# end fluidRow
    )# end fluidPage
)# end shinyUI