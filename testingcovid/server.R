library(shiny)
library(plotly)

server <- function(input, output) {
    options(timeout = 300)
    url <- "https://srhdpeuwpubsa.blob.core.windows.net/whdh/COVID/WHO-COVID-19-global-daily-data.csv"
    temp <- tempfile(fileext = ".csv")
    download.file(url = url, destfile = temp, mode = "wb")
    coviddata <- read.csv(temp, header = TRUE)
    coviddata$Country <- replace(coviddata$Country, coviddata$Country == "Cura�ao", "Curaçao")
    coviddata$Country <- replace(coviddata$Country, coviddata$Country == "R�union", "Réunion")
    coviddata$Date_reported <- as.Date(coviddata$Date_reported)
    output$plotcases <- renderPlotly({
#When WHO region is checked
        if (input$who_region == TRUE) {
            #filtering the who region and date
            datawho <- coviddata[coviddata$WHO_region %in% input$who_select, ]
            data <- datawho[datawho$Date_reported >= input$date_range[1] & datawho$Date_reported <= input$date_range[2], ]
            #creating plot
            plot_ly(data, x = ~Date_reported, y = ~Cumulative_cases, mode = "lines+markers", type = "scatter", color = ~WHO_region, text = ~paste(
                "WHO Region:", WHO_region,
                "<br>New cases:", New_cases,
                "<br>Cumulative cases:", Cumulative_cases
            ), hoverinfo = "text") %>%
            #customization checkboxes
            layout(
                    title = if (input$show_title) "Cumulative Cases" else "",
                    xaxis = list(title = if (input$show_xaxis) "Date reported" else ""),
                    yaxis = list(title = if (input$show_yaxis) "Cumulative cases" else "")
                )
#When WHO region is unchecked
        } else {
            datacountry <- coviddata[coviddata$Country %in% input$country_select, ]
            data <- datacountry[datacountry$Date_reported >= input$date_range[1] & datacountry$Date_reported <= input$date_range[2], ]
            plot_ly(data, x = ~Date_reported, y = ~Cumulative_cases, mode = "lines+markers", type = "scatter", color = ~Country, text = ~paste(
                "Country:", Country, "(", Country_code, ")",
                "<br>WHO Region:", WHO_region,
                "<br>New cases:", New_cases,
                "<br>Cumulative cases:", Cumulative_cases
            ), hoverinfo = "text") %>%
            layout(
                    title = if (input$show_title) "Cumulative Cases" else "",
                    xaxis = list(title = if (input$show_xaxis) "Date reported" else ""),
                    yaxis = list(title = if (input$show_yaxis) "Cumulative cases" else "")
                )
        }
    })
    output$plotdeath <- renderPlotly({
#When WHO region is checked
        if (input$who_region == TRUE) {
            datawho <- coviddata[coviddata$WHO_region %in% input$who_select, ]
            data <- datawho[datawho$Date_reported >= input$date_range[1] & datawho$Date_reported <= input$date_range[2], ]
            plot_ly(data, x = ~Date_reported, y = ~Cumulative_deaths, mode = "lines+markers", type = "scatter", color = ~WHO_region, text = ~paste(
                "WHO Region:", WHO_region,
                "<br>New deaths:", New_deaths,
                "<br>Cumulative deaths:", Cumulative_deaths
            ), hoverinfo = "text") %>%
            layout(
                    title = if (input$show_title) "Cumulative Deaths" else "",
                    xaxis = list(title = if (input$show_xaxis) "Date reported" else ""),
                    yaxis = list(title = if (input$show_yaxis) "Cumulative deaths" else "")
                )
#When WHO region is unchecked
        } else {
            datacountry <- coviddata[coviddata$Country %in% input$country_select, ]
            data <- datacountry[datacountry$Date_reported >= input$date_range[1] & datacountry$Date_reported <= input$date_range[2], ]
            plot_ly(data, x = ~Date_reported, y = ~Cumulative_deaths, mode = "lines+markers", type = "scatter", color = ~Country, text = ~paste(
                "Country:", Country, "(", Country_code, ")",
                "<br>WHO Region: ", WHO_region,
                "<br>New cases:", New_cases,
                "<br>Cumulative cases:", Cumulative_cases
            ), hoverinfo = "text") %>%
            layout(
                    title = if (input$show_title) "Cumulative Deaths" else "",
                    xaxis = list(title = if (input$show_xaxis) "Date reported" else ""),
                    yaxis = list(title = if (input$show_yaxis) "Cumulative deaths" else "")
                )
        }
    })
}