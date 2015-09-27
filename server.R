library(ggplot2)
data(cars)
cars_coefs <- coef(lm(dist ~ speed, data = cars))

shinyServer(
    function(input, output) {
        # MODEL CALIBRATION
        # Get calibration parameters
        intcpt <- reactive({as.numeric(input$intercept)}) # Intercept
        slp    <- reactive({as.numeric(input$slope)})     # Slope
        
        # Output reactive table of calibration parameters
        output$autoCalibrate <- renderText({
            if(input$calibrate > 0) {
                isolate("IN AUTOMATIC CALIBRATION MODE (refresh page to reset)")
            }
        })
        output$ModelParameters <- renderTable({
            if(input$calibrate == 0) {
                parameters <- data.frame(intercept = intcpt(), slope = slp())
            } else {
                parameters <- data.frame(intercept = as.numeric(cars_coefs[1]), 
                                         slope = as.numeric(cars_coefs[2]))
            }
        })
        
        # Output reactive calibration plot
        output$CarScatterPlot <- renderPlot({
            # Create scatter plot of cars data, stopping distance vs speed
            g <- ggplot(cars, aes(speed, dist)) + geom_point(size = 3) +
                xlab("Speed [mph]") + ylab("Stopping distance [ft]") +
                xlim(0,25) +
                scale_y_continuous(limits = c(-25,125), breaks = seq(-25,125,25))
            # Conditionally include approximate of linear regression line
            if(input$calibrate == 0) {
                g <- g + geom_abline(color = "red", size = 1,
                                     intercept = intcpt(), 
                                     slope     = slp()     )
            } else {
                g <- g + geom_abline(color = "red", size = 1,
                                     intercept = as.numeric(cars_coefs[1]), 
                                     slope     = as.numeric(cars_coefs[2]) )
            }
            print(g)
        })
        # PREDICTION
        # Print out specified speed
        output$speedInput <- renderPrint({
            print(as.numeric(input$inputSpeed))
        })
        output$predictedDist <- renderPrint({
            if(input$calibrate == 0) {
                stopping_distance = intcpt() + slp()*as.numeric(input$inputSpeed)
            } else {
                stopping_distance = as.numeric(cars_coefs[1]) + 
                    as.numeric(cars_coefs[2]*input$inputSpeed)
            }
            print(stopping_distance)
        })
    }#end function
)