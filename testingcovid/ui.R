library(shiny)
library(plotly)
options(timeout = 300)
url <- "https://srhdpeuwpubsa.blob.core.windows.net/whdh/COVID/WHO-COVID-19-global-daily-data.csv"
temp <- tempfile(fileext = ".csv")
download.file(url = url, destfile = temp, mode = "wb")
coviddata <- read.csv(temp, header = TRUE)
coviddata$Country <- replace(coviddata$Country, coviddata$Country == "Cura�ao", "Curaçao")
coviddata$Country <- replace(coviddata$Country, coviddata$Country == "R�union", "Réunion")
coviddata$Date_reported <- as.Date(coviddata$Date_reported)

ui <- fluidPage(
    titlePanel("COVID-19 Cumulative Cases and Deaths"),
    tabsetPanel(
        tabPanel(
            #Tutorial for users
            "Tutorial",
            h2("Peer-Graded Assignment Developing Data Products Week 4"),
            h3("by Rafaelangelo Yudhistira Dharmawangsa"),
            p("The purpose of this Shiny App is to complete the Developing Data Products Course by John Hopkins University on Coursera"),
            h3(tags$b("How to use this app")),
            p("This dashboard shows COVID-19 cumulative cases and deaths across countries or WHO regions."),
            tags$ul(
                tags$li("Select a date range to filter the data in the Cases or Deaths tabs."),
                tags$li("Choose Country or WHO Region mode."),
                tags$li("Select one or multiple locations."),
                tags$li("Use checkboxes to customize plot appearance."),
                tags$li("Switch between Cases and Deaths tabs."),
                tags$li("Hover over plots for details.")
            ),
            h4("Notes"),
            p("Data is based on WHO COVID-19 global daily reports."),
            p(
                tags$b("Source: "),
                tags$a(
                    href = "https://data.who.int/dashboards/covid19/data",
                    "WHO Data Statistical Release",
                    target = "_blank"
                )
            ),
            p("Last Modified: 2026-05-24")
        ),
        tabPanel(
            #Cumulative cases tab
            "Cumulative Cases",
            sidebarLayout(
                sidebarPanel(
                    #date input
                    dateRangeInput("date_range", "Choose Time Period",
                                   min = "2020-01-04", max = "2026-05-03"),
                    checkboxInput("who_region", "Switch to WHO Region", FALSE),
                    conditionalPanel(
                        condition = "input.who_region == false",
                        selectizeInput("country_select", "Choose a Country",
                                       choices = unique(coviddata$Country),
                                       multiple = TRUE)
                    ),
                    conditionalPanel(
                        condition = "input.who_region == true",
                        selectizeInput("who_select", "Choose WHO Region",
                                       choices = unique(coviddata$WHO_region),
                                       multiple = TRUE)
                    ),
                    #check box input
                    checkboxInput("show_xaxis", "Show X Axis", TRUE),
                    checkboxInput("show_yaxis", "Show Y Axis", TRUE),
                    checkboxInput("show_title", "Show Plot Title", TRUE)
                ),
                mainPanel(
                    plotlyOutput("plotcases")
                )
            )
        ),
        tabPanel(
            #Cumulative deaths tab
            "Cumulative Deaths",
            sidebarLayout(
                sidebarPanel(
                    #date input
                    dateRangeInput("date_range", "Choose Time Period",
                                   min = "2020-01-04", max = "2026-05-03"),
                    checkboxInput("who_region", "Switch to WHO Region", FALSE),
                    conditionalPanel(
                        condition = "input.who_region == false",
                        selectizeInput("country_select", "Choose a Country",
                                       choices = unique(coviddata$Country),
                                       multiple = TRUE)
                    ),
                    conditionalPanel(
                        condition = "input.who_region == true",
                        selectizeInput("who_select", "Choose WHO Region",
                                       choices = unique(coviddata$WHO_region),
                                       multiple = TRUE)
                    ),
                    #check box input
                    checkboxInput("show_xaxis", "Show X Axis", TRUE),
                    checkboxInput("show_yaxis", "Show Y Axis", TRUE),
                    checkboxInput("show_title", "Show Plot Title", TRUE)
                ),
                mainPanel(
                    plotlyOutput("plotdeath")
                )
            )
        )
    )
)
