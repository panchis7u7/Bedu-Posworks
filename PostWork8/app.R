## app.R ##

## Dashboard Postwork 8
library(shinydashboard)
library(shiny)
library(dplyr)
#install.packages("shinythemes")
library(shinythemes)
library(ggplot2)
data<-read.csv("data.csv")
data<-as.data.frame(data)
daf<-as.data.frame(read.csv("match.data.csv"))

#Esta parte es el análogo al ui.R
ui <- 
    
    fluidPage(
        
        dashboardPage(
            
            dashboardHeader(title = "Postwork 8. Equipo 3"),
            
            dashboardSidebar(
                
                sidebarMenu(
                  menuItem("Integrantes", tabName = "integrantes", icon = icon("file-picture-o")),
                    menuItem("Gráfica de barras", tabName = "Dashboard", icon = icon("dashboard")),
                    menuItem("Imágenes PW3", tabName = "graph", icon = icon("file-picture-o")),
                    menuItem("Data Table", tabName = "data_table", icon = icon("table")),
                    menuItem("Imágenes", tabName = "img", icon = icon("file-picture-o"))
                )
                
            ),
            
            dashboardBody(
                
                tabItems(
                    
                  
                  
                  
                  tabItem(tabName = "integrantes",
                          fluidRow(
                            titlePanel("BEDU - Fase II"), 
                            titlePanel(h3("Diego Armando Morales Corona")),
                            titlePanel(h3("Carlos Rodríguez Tenorio")),
                            titlePanel(h3("Viridiana Escarzaga Solís")),
                            titlePanel(h3("Carlos Sebastián Madrigal Rodríguez"))
                                                  )
                  ),
                    # Histograma
                    tabItem(tabName = "Dashboard",
                            fluidRow(
                                titlePanel("Gráficas de barras"), 
                                selectInput("x", "Seleccione el equipo local",
                                            choices = unique(data$HomeTeam)),
                                
                                selectInput("zz", "Selecciona el equipo visitante", 
                                            
                                            choices = unique(data$AwayTeam)),
                                box(plotOutput("plot1", height = 500)),
                                box(plotOutput("plot2", height = 500)),
                                
                            )
                    ),
                    
                    # Gráficas en imágenes del PW3
                    tabItem(tabName = "graph",
                            fluidRow(
                                titlePanel(h2("Gráficas del postwork 3")),
                                titlePanel(h3("Pestaña con las imágenes de las gráficas del Postwork 3")),
                                img( src = "pw3_1.png", 
                                     height = 400, width = 500),
                                img( src = "pw3_2.png", 
                                     height = 400, width = 500),
                                img( src = "pw3_3.png", 
                                     height = 500, width = 500)
                                
                            )
                    ),
                    
                    
                    
                    tabItem(tabName = "data_table",
                            fluidRow(        
                                titlePanel(h3("Data Table")),
                                tableOutput("table"),
                               
                            ))
                    , 
                    
                    tabItem(tabName = "img",
                            fluidRow(
                                titlePanel(h3("Gráficas de los factores de ganancia máximos y mínimos")),
                                img( src = "graf.png", 
                                     height = 500, width = 500),
                                img( src = "graf1.png", 
                                     height = 500, width = 500)
                            )
                    )
                    
                )
            )
        )
    )

#De aquí en adelante es la parte que corresponde al server

server <- function(input, output) {
    
    
    
    #Gráfico de Barras
    output$plot1 <- renderPlot({
        
      
    
        ggplot(data %>% filter(HomeTeam==input$x), aes(HomeTeam, FTHG)) + 
            geom_col() +
            theme_classic() + 
            xlab(input$x) + ylab("Goles de equipo local")+
            facet_wrap(~AwayTeam)
        
        
    })
    
    output$plot2 <- renderPlot({
        
        
        ggplot(data %>% filter(AwayTeam==input$zz), aes(AwayTeam, FTAG)) + 
            geom_col() +
            theme_classic() + 
            xlab(input$zz) + ylab("Goles de equipo visitante")+
            facet_wrap(~HomeTeam)
        
        
    })  
    
    # Agregando el dataframe
    output$table <- renderTable({ 
        data.frame(daf)
    })
    
    #Agregando el data table
  
    
}


shinyApp(ui, server)